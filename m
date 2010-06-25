Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab0FYXrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 19:47:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44124 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab0FYXrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 19:47:13 -0400
MIME-Version: 1.0
In-Reply-To: <5facd128-d48a-4b9e-9b4e-83cabcf33921@SG2EHSMHS003.ehs.local>
References: <20100625220300.6903.3519.stgit@angua> <b392c10f-78bb-466d-a3e0-cf5b95edb4cb@VA3EHSMHS014.ehs.local> 
	<AANLkTilvOpCVrbT4YPaw3NZUCnKgUN7IUQzQGMfihbSG@mail.gmail.com> 
	<bb9a6620-ccf1-4f5b-a1cd-97f93bad4baa@SG2EHSMHS007.ehs.local> 
	<AANLkTik_lg0H4-ajyuCmH9LwhY0nAfo4-sax8ETC984h@mail.gmail.com> 
	<5facd128-d48a-4b9e-9b4e-83cabcf33921@SG2EHSMHS003.ehs.local>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 25 Jun 2010 17:46:52 -0600
X-Google-Sender-Auth: 5_wkhJk_7DsQRb1d4h5J5QtE6LE
Message-ID: <AANLkTik5MsUycP_OVJyr__zbCeqIsKvkhc8MoAdco5En@mail.gmail.com>
Subject: Re: [PATCH] of/flattree: Use common ALIGN() macro instead of 
	archspecific _ALIGN
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: benh@kernel.crashing.org, monstr@monstr.eu,
       microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, jeremy.kerr@canonical.com,
       sfr@canb.auug.org.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 5:36 PM, Stephen Neuendorffer
<stephen.neuendorffer@xilinx.com> wrote:
>
>
>> -----Original Message-----
>> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
>> Sent: Friday, June 25, 2010 4:34 PM
>> To: Stephen Neuendorffer
>> Cc: benh@kernel.crashing.org; monstr@monstr.eu; microblaze-uclinux@itee.uq.edu.au; devicetree-
>> discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org; jeremy.kerr@canonical.com;
>> sfr@canb.auug.org.au
>> Subject: Re: [PATCH] of/flattree: Use common ALIGN() macro instead of archspecific _ALIGN
>>
>> On Fri, Jun 25, 2010 at 5:18 PM, Stephen Neuendorffer
>> <stephen.neuendorffer@xilinx.com> wrote:
>> >> -----Original Message-----
>> >> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
>> >> Sent: Friday, June 25, 2010 4:16 PM
>> >> To: Stephen Neuendorffer
>> >> Cc: benh@kernel.crashing.org; monstr@monstr.eu; microblaze-uclinux@itee.uq.edu.au; devicetree-
>> >> discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org; jeremy.kerr@canonical.com;
>> >> sfr@canb.auug.org.au
>> >> Subject: Re: [PATCH] of/flattree: Use common ALIGN() macro instead of archspecific _ALIGN
>> >>
>> >> On Fri, Jun 25, 2010 at 4:49 PM, Stephen Neuendorffer
>> >> <stephen.neuendorffer@xilinx.com> wrote:
>> >> > Grant,
>> >> >
>> >> > I need this for the PCI project.  I also have a couple of other
>> >> > generalizations of the drivers/of code
>> >> > to get it to run after boot time in an X86 system...
>> >>
>> >> Send me your patches!  :-)  Get them to me soon and I'll queue them up
>> >> for the next merge window.
>> >>
>> >> g.
>> >
>> > Dangit, I just got the code compiling, and now I find out that X86 doesn't support out_be32()...  :)
>> > You'd think that somewhere somebody might have realized that all the duplicated driver macros that
>> > do that are a bad idea...
>>
>> :-)
>>
>> I think iowrite32be should be cross-arch safe.  in_*, out_* was mostly
>> a powerpc/sparc thing.
>>
>> g.
>
> See.. I told you it was a good idea to have that abstracted.. :)

'course the real problem is not the access macros, but rather the fact
that sometime the xilinx registers are wired up as big-endian, and
sometimes as little-endian.

g.
