Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab1ANP3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:29:49 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59047 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab1ANP3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:29:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=aSOFRU6HIPcccL3Xsl07x3Zr/8rM0dkf5ZsYl6LnzSph+aCGFAsIVlmyeBvo+QthTc
         zXpGcnz095d47IEMt3fJsMqjMgxzektrKyctY3zt3DWQTGvhNRze7yo3VUB+SdDf66Xs
         LGoND9pIKydPbngz3Ugg973wskDVPBMqoA1Qc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110114154458.GA18289@fedora14-r610.oslab.blr.amer.dell.com>
References: <20110112203414.GA5657@fedora14-r610.oslab.blr.amer.dell.com>
	<20110112160229.7b8d82c1@jbarnes-desktop>
	<alpine.LFD.2.02.1101122217370.19754@x980>
	<20110113075556.789ac3c3@jbarnes-vaio.home>
	<20110113162755.GA5872@fedora14-r610.oslab.blr.amer.dell.com>
	<20110114154458.GA18289@fedora14-r610.oslab.blr.amer.dell.com>
Date: Fri, 14 Jan 2011 16:29:42 +0100
Message-ID: <AANLkTimba7FFowzVV6KxwvXGis4d0FmxcxZA6NL0saNM@mail.gmail.com>
Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by allmodconfig
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Narendra_K@dell.com
Cc: jbarnes@virtuousgeek.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, Matt_Domsch@dell.com,
        Charles_Rose@dell.com, Surya_Prabhakar@dell.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 4:22 PM,  <Narendra_K@dell.com> wrote:
> On Thu, Jan 13, 2011 at 09:33:56PM +0530, K, Narendra wrote:
>> On Thu, Jan 13, 2011 at 09:25:56PM +0530, Jesse Barnes wrote:
>> > On Wed, 12 Jan 2011 22:23:55 -0500 (EST)
>> > Len Brown <lenb@kernel.org> wrote:
>> > > > So there's no other ACPI code that depends on this function?  I'd hate
>> > > > to make PCI depend on NLS, so assuming ACPI doesn't need it (in which
>> > > > case the select or depend should be there), I guess it should be pulled
>> > > > into a common file that will always be included.
>> > >
>> > > No, nothing in the ACPI code uses utf16s_to_utf8s.
>> > >
>> > > I don't know anything about NLS, but it appears to be
>> > > something that file systems (befs, cifs, fat, hfs, isofs, jfs, etc)
>> > > use to to support native languages.
>> > >
>> > > BTW. I don't understand why pci-label.o appears twice above.
>> > > It used to be just the 2nd one, that depends on CONFIG_DMI.
>> >
>> > Ok, I'll drop this patch for now then since I haven't seen a fix yet
>> > and need to get Linus the rest of the changes.
>>
>> Jesse,
>>
>> I just compile tested a fix on the following lines without any failure.
>> If it is acceptable, i will send a patch in half an hour. It builds
>>
>
> Hello,
>
> This patch addresses the build failure described in this thread by
> compiling fs/nls/nls_base.c always into vmlinux, thus making the base
> nls functions available always.
>
> Please consider this patch for inclusion if there are no concerns with
> this approach.
>

So NLS is built always?
You thought of embedded devices like router platforms which want to
reduce their kernel (size) by not building NLS?

- Sedat -
