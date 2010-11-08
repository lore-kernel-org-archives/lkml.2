Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab0KHTgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:36:42 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47910 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab0KHTgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:36:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WW0Iy4xTVI9zcqBGRnVdG7HlbQ38NeANufZtUNXkzMqNAa2roNiCdknTU+QnhlPvvd
         Sd3kjTzRYcLRKOdxhdsw9enyXAarIlcOXJsJYfd6L1wCuXXcP+buexzV/mInCpEXWobv
         DkcABubStxSKdJ3sZEnHCxqG7KYkZBgirMGac=
MIME-Version: 1.0
In-Reply-To: <20101108190258.GA1623@arch.trippelsdorf.de>
References: <20101108170221.GA1602@arch.trippelsdorf.de>
	<20101108170737.GA1617@arch.trippelsdorf.de>
	<20101108184301.GA1614@arch.trippelsdorf.de>
	<20101108190258.GA1623@arch.trippelsdorf.de>
Date: Mon, 8 Nov 2010 14:36:39 -0500
Message-ID: <AANLkTimT71Y_hFVjKbY5GFBJ7wP9AWo8RgurYiftneo+@mail.gmail.com>
Subject: Re: Radeon RS780 - BUG: unable to handle kernel NULL pointer dereference
From: Jerome Glisse <j.glisse@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@linux.ie
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 2:02 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On Mon, Nov 08, 2010 at 07:43:02PM +0100, Markus Trippelsdorf wrote:
>> On Mon, Nov 08, 2010 at 06:07:37PM +0100, Markus Trippelsdorf wrote:
>> > On Mon, Nov 08, 2010 at 06:02:21PM +0100, Markus Trippelsdorf wrote:
>> > > I can trigger a kernel crash on my system by simply loading this png
>> > > image with firefox:
>> > > http://mediaarchive.cern.ch/MediaArchive/Photo/Public/2010/1011251/1011251_01/1011251_01-A4-at-144-dpi.jpg
>> >
>> > Sorry the above link is wrong, this is the right one (that triggers the
>> > crash):
>> > http://cdsweb.cern.ch/record/1305179/files/HI-150431-630470-huge.png
>>
>> I triggered it a few more times and took the attached picture.
>> It points to the BUG() call at drivers/gpu/drm/ttm/ttm_bo.c:1628 .
>> (Sorry for the bad picture quality)
>
> And here the same BUG in plaintext (should be a bit easier to read):
>
> Nov  8 19:28:23 arch kernel: ------------[ cut here ]------------
> Nov  8 19:28:23 arch kernel: kernel BUG at drivers/gpu/drm/ttm/ttm_bo.c:1628!

Quite puzzling it is as if there was already a bo at same offset in rb
tree but not
in vm mm. Maybe some other race in destruction...

Cheers,
Jerome Glisse
