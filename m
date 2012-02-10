Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab2BJNKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:10:41 -0500
Received: from nm19-vm0.bullet.mail.ird.yahoo.com ([77.238.189.92]:30485 "HELO
	nm19-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758757Ab2BJNKj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:10:39 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 637575.72083.bm@omp1031.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xZYgX10wtzSI8DfUv9wfdym08WW+HBj6wTYXGUxqHL9Z8e3jWIa3MaekxYe9m52Ss2CuQ0REfdp5fUS4bOFCmS/ig7TUxP2QrP0eTlznP/AbOH5kCqs0kzCXHgsQtxJ+eGm/Dux3nEJ0nx5T2EvOfkQ3EK9dDFQXxO0cQOWz/b0=;
X-YMail-OSG: qlcUMm4VM1mQKlJGGwi18LtGLBN7PEe4waOFkHfQhcIqlRV
 lfHEwvt86tiMqY55.lV75t5BK34xMhogRNm366VGsLnVSsAw.fei.0oCjL0P
 7B5bTm3MxXpMJd3BAlyyQRApdABBik0VzyYyerVOFXD6r09e9lBKBTYLPYHB
 ZgQvpUKcnL7d7say9FRyuLCGBaL6YzpX_fu27lfFIZZXB8DjZWhcZ4a8RP6o
 NpVRo0mBDaClIm1FnDZFDuOm9twvQXEpkhdV3MCSrMl0bi39lBw.3tRT2Hb0
 K3swbDGgtVychA8u0fCtmwZjWRpnGfFGuJOPGIr9A0Yy8A_cjkEcAUzcx8NB
 ZPL18e4bi66ivZIUgkDR00cTqZ0F_AU8WyauDcYpxySmbmglEayxkRdPubVn
 Qy4ie2PygocgCaWmCD6BjL6.3UtMVnVDcH2VyPVOAVw9sawfwsDimg6w-
X-Mailer: YahooMailClassic/15.0.4 YahooMailWebService/0.8.116.338427
Message-ID: <1328879437.80871.YahooMailClassic@web29006.mail.ird.yahoo.com>
Date: Fri, 10 Feb 2012 13:10:37 +0000 (GMT)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: No /dev/root with devtmpfs?
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120210090425.GA3997@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 10/2/12, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> > Could you simply use /etc/fstab to identify the root
> partition?
> 
> Unfortunately no, because /etc/fstab can't know where the
> card will be
> inserted to boot this time - i.e. either in compactflash
> slot on
> motherboard, or through usb via cardreader. So root has to
> be determined
> at runtime.
> 
> Personally I'm ok with no /dev/root symlink as long as there
> is another
> way to detect root blkdev reliably. And I'm still confised
> what's the
> rationale about why this can't be done for modern
> filesysems.

Here's another suggestion: /proc/cmdline

The bootloader might pass the root partition to the kernel via the
"root=" kernel parameter; these can be read at /proc/cmdline.
For example, on an HP iPAQ hx4700: root=/dev/mtdblock2

