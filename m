Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab0FWVfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 17:35:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47994 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0FWVfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 17:35:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=J2kv7cGGIkuHu1rOBRcQNQlJYYhr/mVdYfRWMvYHJOUfbJPVgDLEoeUvbG5lxtvaBU
         uiGhRVGGWTxdQWjuv/ygKaeXAivQOePKGV1RNXrdUF37i6ugeqveUUKOBZW4qrbGxuPG
         RoE57N986DIrLhVcuCt7H4G7eUIc5lFZzZXhU=
Message-ID: <4C227E27.7060604@gmail.com>
Date: Wed, 23 Jun 2010 23:35:35 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1rc2-2.2 Thunderbird/3.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: akpm@linux-foundation.org, adobriyan@gmail.com, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH v3 06/11] rlimits: do security check under task_lock
References: <20100513155621.51ca77a4.akpm@linux-foundation.org> <1275855783-27316-1-git-send-email-jslaby@suse.cz> <20100607180855.GA6689@redhat.com> <4C222644.4040601@gmail.com> <20100623161254.GA10098@redhat.com> <4C224804.7030809@gmail.com> <20100623175602.GA14824@redhat.com>
In-Reply-To: <20100623175602.GA14824@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 07:56 PM, Oleg Nesterov wrote:
> On 06/23, Jiri Slaby wrote:
>> I still see no way how this is wrong. We want to check whether current
>> thread has capabilities to change (someone else's) rlimits.

You know, this is one of those sentences where you wonder what kind of
idiot wrote that. And then you find out it was you being totally off base.

> Yes. but what is "someone else" ?

I don't know what was I thinking of. Indeed you are correct. When I was
writing that I was somehow under the impression (dunno why) that 'p' is
current process and the code checks whether 'p' can do the change. But
we are indeed checking whether 'current' may change 'p's limits -- or
better, as you wrote, not of the thread 'p' itself, but of its whole
process.

I'll resend a new version with you all in CCs to see what we can do with
the patches, if anything.

thanks,
-- 
js
