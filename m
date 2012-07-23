Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2GWXsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 19:48:22 -0400
Received: from nm31-vm5.bullet.mail.bf1.yahoo.com ([72.30.239.13]:35105 "HELO
	nm31-vm5.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754877Ab2GWXsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 19:48:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 134618.93071.bm@omp1025.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=UqMisTNzfRd19S2pyE/CSKtIkJgjMFlaycaFMcqvAUmKYhSo85v7EQ+A/i5/oAqrqdyzL90eAVxvowkdPEQc7/V0AEtxdnOY0VRGbqm9hvBHapaV5bL/SWNCQGelk1VLkMiSIzaNyNZlmR5GhEx+vt0jxCBH+rkle2FJy5QmHJE=;
X-YMail-OSG: BitALcQVM1mUIDgA2Nj0u_urdBFjmVoKsERrLsIeSyLn3lt
 E0ve7SnEXcqMN0hcsdaPuXaa0K_Hoi0f7oVxB6wV8nCRVvHjtvJjwJ769EBk
 eKjh_boPqToXwjoQtKvGLTuQjdkFPFk611GDRyZXHXNjpqJkzkslIvDQkrr1
 37sym.aYwb7YqdjgzxQTNFR4NG4L6NlhhXty3g5yS_8Lr7HiQa.LhQ8W2X77
 EMQu2acS7WFGSUwfhlJvFGFIWi_j9zPV1LT8cNNkAi_nGSHg0fEB6j47JDAE
 iLkm11kXYUOoz7qmSfYcJtRUAC0aPg0iV81IKO0rLWnpDVTMIEo6hdVHt_fk
 f8dd2c8.CtEX9Pq6ZQqty3mEYiQqorfNvutYmKFVi5R9bMzB8lnoFajVkvjd
 Do9JjsLyAKPXHnGwNTnUh864MHnyboVunKhALhEGl54WLoXMf86AqJ.36otV
 TnZ6dvB8LuQ8SGi5zZmEkoBW_duiPTQz2VAsuJmG8Bx4.v3fUFyMyiiPmKB0
 n6QIg.NImBVEeB7Ocdce6mUL_nLaa256Ny1uGTuWuxahDtJf2Qs2u8tIcxdU
 ZphuvY_K2grVi38MZ0TXDuMg2LZokKt097Vqb_Q--
X-Mailer: YahooMailWebService/0.8.120.356233
References: <1342735724.60460.YahooMailNeo@web160604.mail.bf1.yahoo.com> <20120720093648.GA3909@router-fw-old.local.net-space.pl>
Message-ID: <1343087299.65126.YahooMailNeo@web160606.mail.bf1.yahoo.com>
Date: Mon, 23 Jul 2012 16:48:19 -0700 (PDT)
From: joe shmoe <joeshmoeypeter@yahoo.com>
Reply-To: joe shmoe <joeshmoeypeter@yahoo.com>
Subject: Re: kdump/kexec vmcore size doubles each time
To: Daniel Kiper <dkiper@net-space.pl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        daniel.kiper@oracle.com
In-Reply-To: <20120720093648.GA3909@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thank you for the reply. I ended up opting for writing to filesystem rather than raw_device and this seems to have helped me sidestep the problem for now. Unfortunately, I can't quite make a jump to later sources.

I do have another question, I see KDUMP_KEEP_OLD_DUMPS mentioned to automatically clean up prior dumps (for ex: http://dedoimedo.com/computers/kdump.html and other SUSE docs).
However, I cannot find any logic in sources to do this (and sure enough I don't see older cores in my /var/crash/ path clean up as new cores are dumped).

Could someone please comment if:
(i) KDUMP_KEEP_OLD_DUMPS is unsupported or not. If it IS supported, could someone please help with the relevant source code so I could debug why it isn't working? Yes, I did download kexec-tools git but cannot find anything relevant.

(ii) If there is NO explicit source code to achieve this -- then do folks achieve such a cleanup through KDUMP_PRE and KDUMP_POST scripts? If yes, is there a standard-ish script out there to achieve this?

Thanks much.

----- Original Message -----
From: Daniel Kiper <dkiper@net-space.pl>
To: joe shmoe <joeshmoeypeter@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; daniel.kiper@oracle.com
Sent: Friday, July 20, 2012 2:36 AM
Subject: Re: kdump/kexec vmcore size doubles each time

On Thu, Jul 19, 2012 at 03:08:44PM -0700, joe shmoe wrote:
> Hi,
> I am trying to configure kexec/kdump on 2.6.35-14.
>
>
> $> kexec --version
> kexec-tools-testing 20080330 released 30th March 2007

[...]

It is very ancient version. Please use at least Ver. 2.0.3
(http://kernel.org/pub/linux/utils/kernel/kexec/) or current
development version (git://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git).

Daniel

