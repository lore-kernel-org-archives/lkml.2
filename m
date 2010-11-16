Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934366Ab0KPMVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 07:21:12 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:34332 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab0KPMVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:21:10 -0500
X-Auth-Info: 0cPL9DEFqwb+te48BC/JXNBjZ4n7z3unazhCEsHJnjE=
Message-ID: <4CE2777E.30501@grandegger.com>
Date: Tue, 16 Nov 2010 13:22:22 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, margie.foster@intel.com, yong.y.wang@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v4] can: Topcliff: PCH_CAN driver: Add Flow
 control/Fix	Endianess issue/Separate IF register/Enumerate LEC macro/Move
 MSI	processing/Use BIT(X)/Change Message Object index/Add prefix PCH_
References: <4CE275A4.9010400@dsn.okisemi.com>
In-Reply-To: <4CE275A4.9010400@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 01:14 PM, Tomoya MORINAGA wrote:
> Add flow control processing.
> Currently, there is no flow control processing.
> Thus, Add flow control processing as
> when there is no empty of tx buffer,
> netif_stop_queue is called.
> When there is empty buffer, netif_wake_queue is called.
> 
> 
> Fix endianness issue.
> there is endianness issue both Tx and Rx.
> Currently, data is set like below.
> Register:
>  MSB---LSB
>  x x D0 D1
>  x x D2 D3
>  x x D4 D5
>  x x D6 D7
> 
> But Data to be sent must be set like below.
> Register:
>  MSB---LSB
>  x x D1 D0
>  x x D3 D2
>  x x D5 D4
>  x x D7 D6  (x means reserved area.)
> 
> 
> Separate interface register from whole of register structure.
> CAN register of Intel PCH EG20T has 2 sets of interface register.
> To reduce whole of code size, separate interface register.
> As a result, the number of function also can be reduced. 
> 
> 
> Enumerate LEC macro from #define macro.
> For easy to readable, all LEC #define macros are replease to enums like below.
> enum pch_can_err {
> 	PCH_STUF_ERR = 1,
> 	PCH_FORM_ERR,
> 	PCH_ACK_ERR,
> 	PCH_BIT1_ERR,
> 	PCH_BIT0_ERR,
> 	PCH_CRC_ERR,
> 	PCH_LEC_ALL,
> };
> 
> 
> Move MSI processing to probe/remove processing.
> Currently, in case this driver is integrated as module, and 
> when this module is re-installed, no interrupts is to be occurred.
> For the above issue, move MSI processing to open/release processing.
> 
> 
> Replace bit assignment value to BIT(X).
> For easy to readable, replace all bit assigned macros to BIT(X)
> 
> 
> Change Message Object index macro name.
> For easy to readable, add Message Object index like below.
> PCH_RX_OBJ_START
> PCH_RX_OBJ_END
> PCH_TX_OBJ_START
> PCH_TX_OBJ_END
> 
> 
> Add prefix PCH_ to all of #define macros.
> For easy to readable, add prefix "PCH_" to all of #define macros.
> 
> 
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Acked-by: Wolfgang Grandegger <wg@grandegger.com>

Thanks for your contribution.

Wolfgang.
