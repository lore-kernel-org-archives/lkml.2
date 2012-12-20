Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2LTMNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 07:13:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:46162 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab2LTMNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:13:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,322,1355126400"; 
   d="scan'208";a="260162948"
From: "Xiao, Jin" <jin.xiao@intel.com>
To: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "Douglas, William" <william.douglas@intel.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "Pillet, VincentX" <vincentx.pillet@intel.com>
Subject: RE: [PATCH] n_gsm.c: add tx_lock in gsm_send
Thread-Topic: [PATCH] n_gsm.c: add tx_lock in gsm_send
Thread-Index: AQHN3qaFjVB5R+A/+kOn8SV2u93iopghk0QA
Date: Thu, 20 Dec 2012 12:13:07 +0000
Message-ID: <375E373B4157DC49B89CEAE588F836F50FE455C5@SHSMSX102.ccr.corp.intel.com>
References: <1355963920.9600.99.camel@xiaojin>
 <20121220114411.4dcc81bb@pyramind.ukuu.org.uk>
In-Reply-To: <20121220114411.4dcc81bb@pyramind.ukuu.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan, 

Thanks. But the comment makes me confused. As we see, gsm->output is called by gsm_data_kick too, and it's in the tx_lock...

Best regards,
Jin Xiao


> From: xiaojin <jin.xiao@intel.com>
> Date: Wed, 19 Dec 2012 11:53:43 +0800
> Subject: [PATCH] n_gsm.c: add tx_lock in gsm_send
> 
> All the call to gsm->output should be in the tx_lock, that could avoid 
> potential race from MUX level. But we have no tx_lock in gsm_send.
> 
> This patch is to add tx_lock in gsm_send.

gsm->output calls the transmit method of the underlying tty driver. We
can't do that with interrupts off as some drivers expect to be able to sleep in their output paths.

Alan
