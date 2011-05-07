Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab1EGWh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 18:37:59 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:40839 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029Ab1EGWh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 18:37:57 -0400
Message-ID: <4DC5C9B5.8050805@free.fr>
Date: Sun, 08 May 2011 00:37:41 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Subject: Re: [PATCH 1/7] ns: proc files for namespace naming policy.
References: <m1tyd7p7tq.fsf@fess.ebiederm.org> <1304735101-1824-1-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1304735101-1824-1-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2011 04:24 AM, Eric W. Biederman wrote:
> Create files under /proc/<pid>/ns/ to allow controlling the
> namespaces of a process.
>
> This addresses three specific problems that can make namespaces hard to
> work with.
> - Namespaces require a dedicated process to pin them in memory.
> - It is not possible to use a namespace unless you are the child
>    of the original creator.
> - Namespaces don't have names that userspace can use to talk about
>    them.
>
> The namespace files under /proc/<pid>/ns/ can be opened and the
> file descriptor can be used to talk about a specific namespace, and
> to keep the specified namespace alive.
>
> A namespace can be kept alive by either holding the file descriptor
> open or bind mounting the file someplace else.  aka:
> mount --bind /proc/self/ns/net /some/filesystem/path
> mount --bind /proc/self/fd/<N>  /some/filesystem/path
>
> This allows namespaces to be named with userspace policy.
>
> It requires additional support to make use of these filedescriptors
> and that will be comming in the following patches.
>
> Signed-off-by: Eric W. Biederman<ebiederm@xmission.com>
Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>

