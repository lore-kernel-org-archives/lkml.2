Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2AJKiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:38:46 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:33178 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab2AJKio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:38:44 -0500
Message-ID: <4F0C150F.1020007@parallels.com>
Date: Tue, 10 Jan 2012 14:38:07 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 01/11] SYSCTL: export root and set handling routines
References: <20111214103602.3991.20990.stgit@localhost6.localdomain6>	<20111214104449.3991.61989.stgit@localhost6.localdomain6>	<m1bor6rg39.fsf@fess.ebiederm.org> <4EEEFC54.10700@parallels.com>	<m18vm8g951.fsf@fess.ebiederm.org> <4EEF2C9A.8000403@parallels.com>	<m1pqfkecw0.fsf@fess.ebiederm.org> <4EEF7364.8000407@parallels.com> <m1vcotigyb.fsf@fess.ebiederm.org>
In-Reply-To: <m1vcotigyb.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

03.01.2012 07:49, Eric W. Biederman пишет:
> Stanislav Kinsbursky<skinsbursky@parallels.com>  writes:
>
>> 19.12.2011 20:37, Eric W. Biederman пишет:
>>> Stanislav Kinsbursky<skinsbursky@parallels.com>   writes:
>>>
>>> Doing that independently of the rest of the sysctls is pretty horrible
>>> and confusing to users.   What I am planning might suit your needs and
>>> if not we need to talk some more about how to get the vfs to do
>>> something reasonable.
>>>
>>
>> Ok, Eric. Would be glad to discuss your sysctls plans.
>> But actually you already know my needs: I would like to make sysctls work in the
>> way like sysfs does: i.e. content of files depends on mount maker -
>> not viewer.
>
> What drives the desire to have sysctls depend on the mount maker?

Because we can (will, actually) have nested fs root's for containers. IOW, 
container's root will be accessible from it's creator context. And I want to 
tune container's fs from creators context.

> Especially what drives that desire not to have it have a /proc/<pid>/sys
> directory that reflects the sysctls for a given process.
>

This is not so important for me, where to access sysctl's. But I'm worrying 
about backward compatibility. IOW, I'm afraid of changing path
"/proc/sys/sunprc/*" to "/proc/<pid>/sys/sunrpc". This would break a lot of 
user-space programs.

-- 
Best regards,
Stanislav Kinsbursky
