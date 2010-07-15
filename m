Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994Ab0GOSH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:07:27 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58517 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933730Ab0GOSHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:07:25 -0400
Message-ID: <4C3F4E58.6090501@canonical.com>
Date: Thu, 15 Jul 2010 11:07:20 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 02/13] AppArmor: basic auditing infrastructure.
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>	<1279154621-25868-3-git-send-email-john.johansen@canonical.com>	<AANLkTimGhmUiCMMWaDs5aV4Hg86QvQJs3ZFUSqAdlKAt@mail.gmail.com>	<4C3F391E.5060408@canonical.com> <20100715133615.0a83defa@redhat.com>
In-Reply-To: <20100715133615.0a83defa@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 10:36 AM, Eric Paris wrote:
> On Thu, 15 Jul 2010 09:36:46 -0700
> John Johansen <john.johansen@canonical.com> wrote:
> 
>> On 07/15/2010 08:18 AM, Eric Paris wrote:
>>> On Wed, Jul 14, 2010 at 8:43 PM, John Johansen
>>> <john.johansen@canonical.com> wrote:
> 
>>>> +       if (sa->aad.profile) {
>>>> +               struct aa_profile *profile = sa->aad.profile;
>>>> +               pid_t pid;
>>>> +               rcu_read_lock();
>>>> +               pid = tsk->real_parent->pid;
>>>> +               rcu_read_unlock();
>>>> +               audit_log_format(ab, " parent=%d", pid);
>>>> +               audit_log_format(ab, " profile=");
>>>> +               if (profile->ns != root_ns) {
>>>> +                       audit_log_format(ab, ":");
>>>> +                       audit_log_untrustedstring(ab,
>>>> profile->ns->base.hname);
>>>> +                       audit_log_format(ab, "://");
>>>> +               }
>>>> +               audit_log_untrustedstring(ab, profile->base.hname);
>>>> +       }
>>>
>>> what does this message look like?  I don't think it fits the nice
>>> key=value rules of the audit system....   Are you sure this is what
>>> you want?
>>>
>> it looks like
>> profile=:ns_name://profile_name
> 
> Actually it would be:
> 
> profile=:"ns_name"://"profile_name"
> 
> The 'untrustedstring' call is going to add ""  just making sure you are
> ok with that.  I guess the audit libs will deal with it ok.

right, lets just be on the safe side and switch to namespace=" ", and
profile=" ".  That will avoid any potential problems

thanks Eric

