Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab1AMKp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 05:45:28 -0500
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:39286 "HELO
	web31813.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932732Ab1AMKp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 05:45:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=gWtvUag0y63rAzVE/Xl5m05dbx7k26X4IjMZi9Q8T3I+/aOtMKCMRSuXpBNnuvd4e6GLBsrDRsIgUU07HKJpl1RKR31niPpncGH4AoPR1s5bxqUPcVHA9PIHa9zPQUIqlPP/FmAMdLTCwTQazgnShX4ruy74nfAgh6WDPv8dvuM=;
Message-ID: <419275.23415.qm@web31813.mail.mud.yahoo.com>
X-YMail-OSG: zgLd1RIVM1mhl02AQS5lpKJohKK0A2b94CYMLMY4ds4OhT_
 2nsY.jpwtw2Vn80CaW_iKGsrK.GG.Co8IOp4HBzP1TzD8Uty55OP550_0hjr
 qu1Da29tkbmt4D0AzCFOBuGlpVaj5efQP7LhojGtVEGMYFKO4hdyMKgHnYdG
 xVsDq_QZHfPMzhZOMkjvuew2kJfva2xmSt2DRWNnAJhbjDixgLM97nM2Kav.
 h4hzZiLY7TQvJv1ZbfeTBmANiRoeJfDrX81LaZiJC9Umdikz7md7yzgihTdv
 L8G_iVYySULf1byg83h0AMf84QW1wU4aFWMjCRzAdlee630JGPosDQ4elZX_
 XfGGSbhA-
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.108.291010
Date: Thu, 13 Jan 2011 02:45:24 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: UASP: updates and merges
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UASP driver allows you to connect to UAS devices and use them
as SCSI devices.

I've merged latest master (f87813) and resolved a conflict in drivers/scsi/sd.c by adding back the truncation of the mode sense data.

The UASP driver saw the following update:

    [USB] UASP: factor out GFP flags and make them GFP_ATOMIC
    
    Factor out the GFP flags and make them atomic:
    1) The SCSI subsystem uses GFP_ATOMIC, e.g. before
    calling the host's slave_alloc callback (at the
    time of this commit).
    2) As we are a storage driver doing I/O, we should
    use the lowest denominator (highest priority)
    allocation, and of course we shouldn't sleep, thus
    use GFP_ATOMIC.

The branch can be found here (off of master):
https://github.com/ltuikov/linux-2.6

Original posting of the UASP driver can be found here:
http://marc.info/?l=linux-usb&m=129165511732388&w=2

   Luben

