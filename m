Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab1FTH6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 03:58:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48757 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1FTH6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 03:58:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xMjCv9jI8JybcG/hFzNKBHXH/Ylz1qIIgMPiSxcrrXizxaLogabFrigkGji6HRPYw/
         Zmm4ucRpl783d0sxM+XAM6mCkVTBsOnLDMOVmBW3BdNJfclIsrs4lPpPdxkRw02ondRS
         o3MwHtoHeD7hsdwe0a50nbPxnSZ83bmAE2Lek=
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20110618151227.GB25163@sirena.org.uk>
References: <1308215372-17420-1-git-send-email-myungjoo.ham@samsung.com>
	<20110618151227.GB25163@sirena.org.uk>
Date: Mon, 20 Jun 2011 16:58:09 +0900
X-Google-Sender-Auth: m5yROe1thFcYg23j9en5hW4zQ88
Message-ID: <BANLkTin6hSaNSDd+dEZdkk3F5O5nDYf9yQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Exynos4 NURI: configure regulators and PMIC
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        dg77.kim@samsung.com, kyungmin.park@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Sun, Jun 19, 2011 at 12:12 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jun 16, 2011 at 06:09:31PM +0900, MyungJoo Ham wrote:
>
[]
>
>> +static struct regulator_init_data nuri_max8997_ldo10_data = {
>> +     .constraints    = {
>
> You should be able to use __initdata for a lot of this by the way.
>


Anyway, I've got a question about using __initdata for platform_data entries.

Using __initdata on this entry and other max8997's platform_data did
not create any SECTION MISMATCH warnings.

"Documentation/DocBook/kernel-hacking.tmpl" says, __initdata means
that the content of it may be free'd after boot.


However, the MAX8997 driver uses platform_data's entry (variables
defined in "static struct max8997_platform_data __initdata
nuri_max8997_pdata)
in its normal functions other than its probe function, which are often
called after boot.

Probably, I'm thinking wrong in some place; however, it seems that
there should be SECTION MISMATCH warnings as the MAX8997 driver uses
the pdata, which is declared to be __initdata, in non-_init function.
Or, is it safe to use platform_data (by dev_get_platdata) out of probe
in drivers even if the platdata is declared to be __initdata in the
platform files?

I just can't sure whether I should let probe function copy
platform-data used by non-probe functions to its own local data
assuming that the content may be freed (assuming that the SECTION
MISMATCH warning is not "complete".) or just believe the completeness
of gcc's SECTION MISMATCH warning.


Cheers!

- MyungJoo


-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
