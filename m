Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab1AFXwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:52:35 -0500
Received: from nm11.bullet.mail.sp2.yahoo.com ([98.139.91.81]:25722 "HELO
	nm11.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755078Ab1AFXwa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:52:30 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 905872.92009.bm@omp1035.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=QcBTsmr23eFqfcQoDPUaMS6+RRfNgY9jweRlVbqP06rS/7hnkRaZgKMEg9ji1HKb4jHHRNeurDVVAWmcKbdnIymoA5NZNNIYL+CPCR49iIdMnsFAF0agrNXjvjZr8iJjbADIEASYH+zvgCSwJ5hn7eredbmKYKXK0ztFr1SwwQ4=;
Message-ID: <511724.91814.qm@web180315.mail.gq1.yahoo.com>
X-YMail-OSG: Bqxcd38VM1nXHw096APDWVX65v.nEEYve_UyOtiKx6zkjb8
 2TxfH32g2BsYJFuSEInJwTwVgprw.oeqpCypS.M.9Og3KCh8s_q9P7tZoqr0
 ZxyA1UGrpfTpy9po7z9kBgoFen4tGdB_Qk8sNed1cvDuaa1m9cI3cib7G_18
 yxRvksj6UY7i8E2INq4b4_va_mSkiEfnDxw1T18x1dGma31vbFTZx0NWGjO8
 z5LdfdKnBKIHy92B29ZLWZ_vKl3E_q0g0MlNkOuDtkaC8LUJuvyQcNZyxdGG
 U1HUrip3aRm5_B3OCazEvwj7iKTe5Mpk47Xluxly7Wfs37WkAoXJP4GpmYH2
 mqKeqIEK.tDOKxc2.3DBG4yqn_ipZE9glFeDHHGKR8I4IsYr1W.og.NEG_WE
 nWKM6GlQbgYWx
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Thu, 6 Jan 2011 15:52:28 -0800 (PST)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [PATCH 10/11] ACPI: Drop device flag wake_capable
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
In-Reply-To: <201101062341.27705.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 1/6/11, Rafael J. Wysocki <rjw@sisk.pl> wrote:


> 
> The wake_capable ACPI device flag is not necessary, because
> it is
> only used in scan.c for recording the information


Only  for ACPI, yes? Generically, it records data for any
wake-capable dvice, and is not ACPI-specific...

My bias is that ACPI should  work the way other PM
solutions/hardware work, not collect special cases
unique to ACPI (kind of like this.) ...

 that _PRW
> is
> present for the given device.  That information is
> only used by
> acpi_add_single_object() to decide whether or not to call
> acpi_bus_get_wakeup_device_flags(), so the flag may be
> dropped
> if the _PRW check is moved to
> acpi_bus_get_wakeup_device_flags().

Only if you presume ACPI ....

I'm glad to see that generic-vs-ACPI duplication
of flags vanishing; way back when I started to add
wakeup support, I had to stop part way through ACPI
in large part because wake didn't work well yet in the Linux PM
framework, except for select non-ACPI HW.
(Starting with a USB subset: OTG and hub port sleep and ewakeup); oh, also GPIO wake on some HW, e.g.
or buttons, and switches like MMC/SD card detect. ISTR that stuff still wierds out a bit as it goes
through Linux-ACPI.

Also, to the extent that the ACPI code was supposed
to be generic and not Linux-specific, I thought Len
or someone from Intel should drive such issues.

