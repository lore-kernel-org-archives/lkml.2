Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1GADIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 23:08:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34324 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab1GADIC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 23:08:02 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=v-axftYKJCJ33+9UnfF9NJDAykQ@mail.gmail.com>
References: <1308434431.1050.5.camel@mop> <8739j59zib.fsf@rustcorp.com.au>
 <BANLkTink8YTe=-Tr5Ax3epiFoFCfzcex7w@mail.gmail.com> <87boxshrwe.fsf@rustcorp.com.au>
 <BANLkTinL4r3RfNuA5x6=UK4DCSSJNeZw7w@mail.gmail.com> <87r56m8w2b.fsf@rustcorp.com.au>
 <BANLkTimNpDdp+JBXt0wUjuc0awypJSvXRg@mail.gmail.com> <87fwn18k9h.fsf@rustcorp.com.au>
 <BANLkTi=v-axftYKJCJ33+9UnfF9NJDAykQ@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 1 Jul 2011 05:07:41 +0200
Message-ID: <BANLkTimmTpcPefmWz=H7+4R6-7o4dZ+hnQ@mail.gmail.com>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 13:24, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Thu, Jun 23, 2011 at 02:27, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> On Wed, 22 Jun 2011 12:17:49 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
>>> On Wed, Jun 22, 2011 at 04:00, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>>> > Now we've got that sorted, is there a reason why you changed all the
>>> > signatures rather than just using mod->mkobj in store_uevent()?
>>>
>>> Because we should be able to use the same 'struct module_attribute'
>>> for built-in modules and for loaded modules at the same time. The
>>> current 'struct module_attribute' has 'struct module' references, but
>>> 'struct module' will never exist for built-in modules.
>>>
>>> 'Struct module_kobject' has nice back-pointer to 'struct module', so
>>> this was the simplest to do, and looks still fine, I thought.
>>
>> Yes, it's weird.  The only reason it currently works is because we don't
>> use the mod parameter in param_attr_show and param_attr_store; it's NULL
>> for built-in modules.
>>
>> I'd prefer that patch first, I think: it's a sensible cleanup.
>
> You want the patch split up in two? You want to remove the mod
> parameter somehow?

Can we get these 20 lines of code sorted out please? :)

Kay
