Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab0DUPwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:52:53 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:35398 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755814Ab0DUPwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:52:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=eLOtNlvpGBZt48rFAJCtvgEcKLGhnDMeBg1mJoP+Pe0/mHZPDnB7ChFu+8XWbs6GY96vXuzbDeQfwt1b+WSKG7+OYwhUdhgis/Bg7RVHHRdtX1L95BGipQX1BpaS7/Oo;
Date: Wed, 21 Apr 2010 08:54:08 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Peter Henriksson <peter.henriksson@gmail.com>,
       Clemens Ladisch <clemens@ladisch.de>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [regression, bisected] Xonar DX invalid PCI I/O range since 
 977d17bb174
Message-ID: <20100421085408.33754cd0@virtuousgeek.org>
In-Reply-To: <4BCE95D1.6070105@oracle.com>
References: <4BCBFE89.9070401@ladisch.de>
	<o2gf046f1351004190044h6c3f6536ga916d2fa047f3fe7@mail.gmail.com>
	<4BCC0F10.3070208@ladisch.de>
	<l2sf046f1351004190142ocb2e5f1fyc0e892489caa76a3@mail.gmail.com>
	<4BCCA5FD.6060002@oracle.com>
	<1271706161.2505.6.camel@darwin.lan>
	<4BCD4C8D.7070805@oracle.com>
	<n2yf046f1351004200103zdcf703e6ofea41dc688a5e62e@mail.gmail.com>
	<r2o86802c441004201022i32f328e2n7a125df88f67e390@mail.gmail.com>
	<1271789155.2554.2.camel@darwin.lan>
	<4BCE95D1.6070105@oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 23:06:09 -0700
Yinghai <yinghai.lu@oracle.com> wrote:
> after several times retry, mmio ranges get assigned, but io port range can be allocated enough range. it needs 16k,
> but under 05:01.0 to 08:00.0 and 09:04.0 orginal io port from BIOS allocation get lost.
> 
> wonder be good, if We can restore it for such case.
> 
> current may have to disable bridge resizing feature by default.
> 
> can you send out 
> lspci -vvxxx
> lspci -tv 

Since we don't really know which devices will be in use until drivers
load (and not even then if they're userspace drivers), it might be best
to put off the reassignment until a PCI driver expresses an interest in
the range.

At least, it seems like that would be closer to the ideal approach than
trying to reassign everything at boot, potentially making devices that
don't matter get resources and leaving important devices disabled.

-- 
Jesse Barnes, Intel Open Source Technology Center
