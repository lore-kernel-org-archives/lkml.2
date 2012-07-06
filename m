Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2GFJrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:47:13 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49887 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab2GFJrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:47:11 -0400
Message-ID: <4FF6B37B.4040005@parallels.com>
Date: Fri, 6 Jul 2012 13:44:27 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Serge Hallyn <serge.hallyn@canonical.com>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] fail dentry revalidation after namespace change
References: <1341565747-15374-1-git-send-email-glommer@parallels.com> <87hatli62r.fsf@xmission.com>
In-Reply-To: <87hatli62r.fsf@xmission.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 01:37 PM, Eric W. Biederman wrote:
> Glauber Costa <glommer@parallels.com> writes:
> 
>> When we change the namespace tag of a sysfs entry, the associated dentry
>> is still kept around. readdir() will work correctly and not display the
>> old entries, but open() will still succeed, so will reads and writes.
> 
> Note reads and writes of file handles open before the move should
> continue to work.

Well, yes. But do you see it as a big problem?

This can probably be fixed as well, but I foresee a big hackishness in
the way =p
