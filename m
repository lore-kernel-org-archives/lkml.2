Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1I0KuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:50:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:4537 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab1I0Kt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:49:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,448,1312182000"; 
   d="scan'208";a="21050964"
Date: Tue, 27 Sep 2011 11:58:04 +0100
From: Alan Cox <alan@linux.intel.com>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Cc: linux-serial@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tty/n_gsm: fix a bug in gsm_dlci_data_output
 (adaption = 2 case)
Message-ID: <20110927115804.40ab56dc@bob.linux.org.uk>
In-Reply-To: <1316791376-4863-1-git-send-email-mikhail.kshevetskiy@gmail.com>
References: <1316791376-4863-1-git-send-email-mikhail.kshevetskiy@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011 19:22:55 +0400
Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com> wrote:

> in adaption=2 case we should put 1 or 2 byte with modem status bits
> at the beginning of a buffer pointed by "dp". n_gsm use 1 byte case,
> so it allocate a buffer of len + 1 size. As result we should:
>   * put 1 byte of modem status bits
>   * increase data pointer
>   * put "len" bytes of data
> but actually we have:
>   * increase first byte with the value of modem status bits
>   * decrease "len"
>   * put orig_len - 1 bytes of data starting from the buffer beggining
> This is evidently wrong.
> 
> Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>
