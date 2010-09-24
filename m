Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab0IXNql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:46:41 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:49707 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab0IXNqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:46:39 -0400
Message-ID: <4C9CABB4.3010002@fr.ibm.com>
Date: Fri, 24 Sep 2010 15:46:28 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Ulrich Drepper <drepper@gmail.com>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, Jan Engelhardt <jengelh@medozas.de>,
        linux-fsdevel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux Containers <containers@lists.osdl.org>,
        Ben Greear <greearb@candelatech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 7/8] net: Allow setting the network namespace by fd
References: <m1ocborgq7.fsf@fess.ebiederm.org> <m1hbhgq1v1.fsf@fess.ebiederm.org>
In-Reply-To: <m1hbhgq1v1.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2010 10:51 AM, Eric W. Biederman wrote:
>
> Take advantage of the new abstraction and allow network devices
> to be placed in any network namespace that we have a fd to talk
> about.
>
> Signed-off-by: Eric W. Biederman<ebiederm@xmission.com>
> ---

[ ... ]

> +struct net *get_net_ns_by_fd(int fd)
> +{
> +	struct proc_inode *ei;
> +	struct file *file;
> +	struct net *net;
> +
> +	file = NULL;
> +	net = ERR_PTR(-EINVAL);
> +	file = proc_ns_fget(fd);
> +	if (!fd)
> +		goto out;
> +		return ERR_PTR(-EINVAL);
> +
> +	ei = PROC_I(file->f_dentry->d_inode);
> +	if (ei->ns_ops !=&netns_operations)
> +		goto out;

Is this check necessary here ? proc_ns_fget checks "file->f_op != 
&ns_file_operations", no ?
