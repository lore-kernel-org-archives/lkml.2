Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab0KCCPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 22:15:19 -0400
Received: from nm13-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.244]:20544 "HELO
	nm13-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752581Ab0KCCPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 22:15:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 251679.90243.bm@omp1052.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type;
  b=Mkspj7KIwq0XlaNxssYvonIXhEsnB2NY1aky7imwAOVQhnxQb2CTXOr5ivd1YGagmPdUjW/D28534Y68iXOxxk22XkiThazDPDsrdgRjM8NrUOtfFgbuHSTWrLqIRxdn/9xGEsG4Abznnqu6/16EBFlxtnyMG1YJbJTW2bHtc6o=;
Message-ID: <956998.65651.qm@web180302.mail.gq1.yahoo.com>
X-YMail-OSG: L9tp1iUVM1lmY9TFAdL9gwgqayUH18Jh3jjAIrpzAQJZuQp
 o5HhTtd2zU0QlS44OR7JiN2V4SCWtTHfIvhFAk9zz13nscuPQxwfaKIxroms
 FfE3_riwMWx6pvPfZEpVzw9_3Nm2Na7h1GzuIPQtzKJUZawb5gQ5dEmySX1E
 fIwp6OmgfuF1EB7gQ_Cr7HfeImfYZqkqCeUQsqDomw9172JTFdSDqy0tFwtc
 _Gz.FbR3Jv6ceLCpKpekPc2E829bu0e72_ai10wuJHaqvF5oH4G_etTnMF_p
 rXoCGQuhSeV6snw2h2l6olu0UMRPuqh1I2c5wJzIB9kIqvx0Q8UGm.3yc6l.
 1nXG0itKQAPyOAtcU1F2cQAHZ6XIBiR6D
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Tue, 2 Nov 2010 19:15:16 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4 08/12] gpio: add ti-ssp gpio driver
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        Cyril Chemparathy <cyril@ti.com>
In-Reply-To: <1288124308-14999-9-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Tue, 10/26/10, Cyril Chemparathy <cyril@ti.com> wrote:

> From: Cyril Chemparathy <cyril@ti.com>
> Subject: [PATCH v4 08/12] gpio: add ti-ssp gpio driver

On the assumptions you've tested this *AND* will
resubmit with the previously-requested change of
removing all references to non-existent
"virtual"ness in the driver ... I'll likely
add my ack to that resubmitted version

Also, chip2gpio seems an excessively generic name;
maybe chip2_ti_ssp_gpio or somesuch?

I'd still be happier seeing this "stack" packaged
as a hardware library called by various drivers
(like GPIO, SPI, etc) rather than a core driver
that's called by other drivers.  That seems like
a better structure for various vendors' "SSP"
hardware (multifunction serial interface logic)
since most function drivers just need to poke
the registers a bit differently, and don't have
much to share with a "core driver" beyond a few
setup routines (if that).

- Dave


