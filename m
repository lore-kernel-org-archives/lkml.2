Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab1CQTQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:16:08 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51995 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1CQTQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:16:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TKssw81Gdng6Crk7MyreeQARjdWGINICq/qBp/p/AQJsdQMKxsisQ/zfi9iXqaaCrJ
         5VX32D/D2b3bQTlNSBiXhISC5eltYQUkkvXjzkLbh40QxPQ+S1vdndqtD49Xkh2Ebbqi
         IarNVpwoLY+ezfP/n0CxnYVYC3mX8ICwGKgCY=
MIME-Version: 1.0
In-Reply-To: <20110317114140.GA31407@erda.amd.com>
References: <1300298305-9164-1-git-send-email-robert.richter@amd.com>
 <1300298305-9164-3-git-send-email-robert.richter@amd.com> <AANLkTi=g-Dd957gPxCUfRxVw52T2m6GbswapEAJLnBtP@mail.gmail.com>
 <20110317114140.GA31407@erda.amd.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 17 Mar 2011 15:15:43 -0400
Message-ID: <AANLkTikp1Jrn-yx_=W-d4Lpz+d1+4EMJJho7ACu9UVhT@mail.gmail.com>
Subject: Re: [PATCH 2/2] oprofile: Add __exit attibute to oprofile_arch_exit() functions
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 07:41, Robert Richter wrote:
> On 16.03.11 16:15:49, Mike Frysinger wrote:
>> On Wed, Mar 16, 2011 at 13:58, Robert Richter wrote:
>> >  979048e oprofile: don't call arch exit code from init code on failure
>> >
>> > we may add __exit attibutes to oprofile_arch_exit() functions.
>>
>> i dont think this the way to go.  how about updating one place
>> (include/linux/oprofile.h:oprofile_arch_exit) and making sure all arch
>> files are including that header if they arent already ?  after all, if
>> they arent including that header, the arch code could break without
>> noticing.
>
> do you mean we specify the __exit attribute in the function
> declaration of the header file and make sure it is included
> everythere? I was looking at current implementations in the kernel and
> this is not common. Mostly the attributes are set in the function
> definition.

i think that's because for most functions, there is no matching
prototype in common code.  drivers themselves have no reason to create
such prototypes.

> So I was not sure if that would work. If so, may we skip
> then the __exit attribute in the definition?
>
> GCC doc states: "The keyword __attribute__ allows you to specify
> special attributes when making a declaration."
>
>  http://gcc.gnu.org/onlinedocs/gcc-4.5.1/gcc/Function-Attributes.html#Function%20Attributes
>
> but nothing about that happens if it is in the function definition and
> this is different from the declaration.

if the function prototype is seen in the same file as the function
definition, attributes are carried over.  if it isnt (because the
oprofile header isnt being included), then the attribute will be
ignored for the function definition.
-mike
