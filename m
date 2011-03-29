Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1C2M1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:27:08 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33998 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1C2M1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r5yM8fJiS/bGomLOz+iEQR9b9L79yc8js5TJVwt3EZ/INJhRfv0hFRRYZhuVRgO58w
         Qhx8skx0bigez7IVBFLjNcfu6Uy6tpdp8o7b6hJDYaO6kEYlnCf0BHXt/ndkWMVimHXD
         hU4VhcFxSIx2le4bVYEJQOFBskp9uGCBnrtlI=
MIME-Version: 1.0
In-Reply-To: <1301399454.583.66.camel@e102109-lin.cambridge.arm.com>
References: <9bde694e1003020554p7c8ff3c2o4ae7cb5d501d1ab9@mail.gmail.com>
	<AANLkTinnqtXf5DE+qxkTyZ9p9Mb8dXai6UxWP2HaHY3D@mail.gmail.com>
	<1300960540.32158.13.camel@e102109-lin.cambridge.arm.com>
	<AANLkTim139fpJsMJFLiyUYvFgGMz-Ljgd_yDrks-tqhE@mail.gmail.com>
	<1301395206.583.53.camel@e102109-lin.cambridge.arm.com>
	<AANLkTim-4v5Cbp6+wHoXjgKXoS0axk1cgQ5AHF_zot80@mail.gmail.com>
	<1301399454.583.66.camel@e102109-lin.cambridge.arm.com>
Date: Tue, 29 Mar 2011 13:27:04 +0100
Message-ID: <AANLkTin0_gT0E3=oGyfMwk+1quqonYBExeN9a3=v=Lob@mail.gmail.com>
Subject: Re: kmemleak for MIPS
From: Maxin John <maxin.john@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Baluta <dbaluta@ixiacom.com>, naveen yadav <yad.naveen@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 29, 2011 at 12:50 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Tue, 2011-03-29 at 12:38 +0100, Maxin John wrote:
>> Hi,
>>
>> > You may want to disable the kmemleak testing to reduce the amount of
>> > leaks reported.
>>
>> The kmemleak results in MIPS that I have included in the previous mail
>> were obtained during the booting of the malta kernel.
>> Later, I have checked the "real" usage by using the default
>> "kmemleak_test" module.
>>
>> Following output shows the kmemleak results when I used the "kmemleak_test.ko"
>
> Yes, that's fine to test kmemleak and show that it reports issues on
> MIPS. But it shouldn't report other leaks if the test module isn't
> loaded at all (removing it wouldn't remove the leaks reported as they
> are permanent).

Thank a lot for this information.  Based on this, I will check it
again in the MIPS platform.

>> debian-mips:~# cat /sys/kernel/debug/kmemleak
>> ........
>
> These were caused by the kmemleak test.

Oh.. I am sorry for creating confusion. I have added these lines (
........) just to show that I haven't shared the
complete output in order to reduce the length of the mail.

>>
>> > These are probably false positives.
>> The previous results could be false positives. However, the current
>> results are not false positives as we have intentionally created the
>> memory leaks using the test module.
>
> I was only referring to those leaks coming from udp.c and ignored the
> kmemleak tests (that's why I said that you should run it again without
> the kmemleak_test.ko).
>> > Since the pointer referring this
>> > block (udp_table) is __read_mostly, is it possible that the
>> > corresponding section gets placed outside the _sdata.._edata range?
>>
>> I am not sure about this. Please  let know how can I check this.
>
> Boot the kernel with kmemleak enabled but don't load kmemleak_test.ko.
> Than you can either wait 10-15 minutes or force a scan with:
>
> echo scan > /sys/kernel/debug/kmemleak
> echo scan > /sys/kernel/debug/kmemleak
> cat /sys/kernel/debug/kmemleak.
>

Thanks a lot for sharing the detailed steps.I will perform the test as
mentioned above and will share the results.

Thanks and Regards,
Maxin B. John
