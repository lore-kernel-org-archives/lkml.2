Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab0KEQaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:30:00 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:54513 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab0KEQ35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:29:57 -0400
Message-ID: <4CD430E4.2090907@ge.com>
Date: Fri, 05 Nov 2010 16:29:24 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 04/30] staging/vme: allow non-dynamic allocation of bus
 numbers
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-5-git-send-email-cota@braap.org> <4CC7F3BE.5090503@ge.com> <20101027151327.GR10869@flamenco.cs.columbia.edu> <20101104034056.GC9037@flamenco.cs.columbia.edu>
In-Reply-To: <20101104034056.GC9037@flamenco.cs.columbia.edu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Nov 2010 16:29:38.0812 (UTC) FILETIME=[A430ABC0:01CB7D06]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/10 03:40, Emilio G. Cota wrote:
> On Wed, Oct 27, 2010 at 11:13:27 -0400, Emilio G. Cota wrote:
>> On Wed, Oct 27, 2010 at 10:41:18 +0100, Martyn Welch wrote:
>>> On 26/10/10 02:10, Emilio G. Cota wrote:
>>>> From: Emilio G. Cota <cota@braap.org>
>>>>
>>>> In a configuration with several bridges, each bridge is
>>>> assigned a certain bus number depending on the order in which
>>>> vme_register_bridge is called. This can complicate multi-bridge
>>>> installations because the eventual bus numbers will depend
>>>> on the order the bridges were loaded.
>>>>
>>>> The appended allows bridges to register with a bus number of
>>>> their choice, while keeping the previous 'first come, first
>>>> served' behaviour as the default.
>>>>
>>>
>>> I can't see where this is being used.
>>
>> Each driver's .probe is fed with bus_number and slot_number.
>> Normally the driver will check that pair against what it received
>> through modparams and act accordingly.
>>
>> For this to be reliable bus numbering should be consistent on
>> a given system, i.e. it should be possible to always allocate
>> the same bus number to a given bus. Otherwise, depending on
>> which bridge is installed first, we'd get different bus numbers
>> assigned.
>>
>> Does that make it clearer now?
>>
>>> I assume this is a part of future changes you wish to make?
>>
>> AFAICT it affects the current model.
> 
> Martyn,
> 
> Have you had time to re-check this one?
> 

I'm afraid I haven't - I'm rather tied up at the moment. I'll try and
set aside some time next week to look at the remaining patches you sent.

Martyn


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
