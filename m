Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab1FFRNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:13:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:5157 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461Ab1FFRNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:13:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,327,1304319600"; 
   d="scan'208";a="7936023"
From: "Gorby, Russ" <russ.gorby@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ahmed, Suhail" <suhail.ahmed@intel.com>
Subject: RE: [PATCH 5/5] tty: n_gsm: Fixed NULL ptr OOPs in tty_write_room()
Thread-Topic: [PATCH 5/5] tty: n_gsm: Fixed NULL ptr OOPs in tty_write_room()
Thread-Index: AQHMIjrIXO1xdoIB7E2jINplucbMz5SwlLNA
Date: Mon, 6 Jun 2011 17:13:41 +0000
Message-ID: <330DDCE36F8D7D47BF87CF587C91A247023156@ORSMSX101.amr.corp.intel.com>
References: <[PATCH 0/5] N_GSM patchset : 06/03/2011>
	<1307127821-21665-6-git-send-email-russ.gorby@intel.com>
 <20110603231028.5c267e60@lxorguk.ukuu.org.uk>
In-Reply-To: <20110603231028.5c267e60@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.131.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
>Sent: Friday, June 03, 2011 3:10 PM
>To: Gorby, Russ
>Cc: Greg Kroah-Hartman; linux-kernel@vger.kernel.org; Ahmed, Suhail
>Subject: Re: [PATCH 5/5] tty: n_gsm: Fixed NULL ptr OOPs in
>tty_write_room()
>
>On Fri,  3 Jun 2011 12:03:41 -0700
>Russ Gorby <russ.gorby@intel.com> wrote:
>
>> We saw a case where gsmld_output was called after the MUX
>> was shutdown. In this case gsm->tty was null so tty_write_room(NULL)
>> was called which resulted in an exception.
>
>This is papering over a problem. It shouldn't be happening. Do you have
>a
>copy of the backtrace of the event and does it occur a lot. If it's a
>one
>off freak event so far then instead add
>
>	if (gsm->tty == NULL) {
>		WARN_ON(1);
>		return -ENXIO;
>	}
>
>so we get dumps from it and the box survives when it occurs. That'll get
>us traces to nail it properly. For one your patch is not a valid
>ultimate fix because if it can occur what stops gsm->tty changing as it
>occurs.

[Gorby, Russ] Fair enough - no I don't have a trace and it only happened once. We're also running on the .36 kernel that I've seen some other TTY-weirdness with. I'll add the WARN_ON locally and try to capture another trace for analysis.

