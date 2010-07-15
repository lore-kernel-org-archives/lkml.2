Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805Ab0GOQkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:40:33 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59541 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768Ab0GOQkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:40:32 -0400
Message-ID: <4C3F39FB.7090409@canonical.com>
Date: Thu, 15 Jul 2010 09:40:27 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 04/13] AppArmor: core policy routines
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>	<1279154621-25868-5-git-send-email-john.johansen@canonical.com> <AANLkTim_l1RDI3icW1Ko7NWvECT1JzuM2c3Qqa8wvQR6@mail.gmail.com>
In-Reply-To: <AANLkTim_l1RDI3icW1Ko7NWvECT1JzuM2c3Qqa8wvQR6@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 08:33 AM, Eric Paris wrote:
> On Wed, Jul 14, 2010 at 8:43 PM, John Johansen
> <john.johansen@canonical.com> wrote:
>> The basic routines and defines for AppArmor policy.  AppArmor policy
>> is defined by a few basic components.
>>      profiles - the basic unit of confinement contain all the information
>>                 to enforce policy on a task
>>
>>                 Profiles tend to be named after an executable that they
>>                 will attach to but this is not required.
>>      namespaces - a container for a set of profiles that will be used
>>                 during attachment and transitions between profiles.
>>      sids - which provide a unique id for each profile
>>
>> Signed-off-by: John Johansen <john.johansen@canonical.com>
>> ---
> 
>> +       PFLAG_MMAP_MIN_ADDR = 0x80,     /* profile controls mmap_min_addr */
> 
> You don't actually support this per ?domain? mmap_min_addr and I'm not
> sure how you ever can (given the nature of round_hint_to_min()) so
> maybe you should rip it all out rather than having the half
> implemented stuff in patches 4 and 6?

Right, it wasn't actually ever intended as a per domain value, just a constraint
on the domain setting the value.  As it currently isn't supported I will rip
those bits out.

