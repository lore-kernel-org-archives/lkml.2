Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab0C0GrF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 02:47:05 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41161 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751825Ab0C0Gqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 02:46:52 -0400
Date: Sat, 27 Mar 2010 07:46:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35rx_s.h Coding style fixes.
Message-ID: <20100327064638.GN18689@elf.ucw.cz>
References: <1269553266-4987-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269553266-4987-1-git-send-email-lindley@coyote.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-03-25 22:41:06, Lars Lindley wrote:
> I fixed all checkpatch problems except for a couple of long lines.
> I also removed version comments.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

ACK.

> ---
>  drivers/staging/winbond/wb35rx_s.h |   63 +++++++++++++++++++-----------------
>  1 files changed, 33 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/staging/winbond/wb35rx_s.h b/drivers/staging/winbond/wb35rx_s.h
> index 4b03274..3cd0add 100644
> --- a/drivers/staging/winbond/wb35rx_s.h
> +++ b/drivers/staging/winbond/wb35rx_s.h
> @@ -1,44 +1,47 @@
> -//============================================================================
> -// wb35rx.h --
> -//============================================================================
> -
> -// Definition for this module used
> -#define MAX_USB_RX_BUFFER	4096	// This parameter must be 4096 931130.4.f
> -
> -#define MAX_USB_RX_BUFFER_NUMBER	ETHERNET_RX_DESCRIPTORS		// Maximum 254, 255 is RESERVED ID
> -#define RX_INTERFACE				0	// Interface 1
> -#define RX_PIPE						2	// Pipe 3
> -#define MAX_PACKET_SIZE				1600 //1568	// 8 + 1532 + 4 + 24(IV EIV MIC ICV CRC) for check DMA data 931130.4.g
> -#define RX_END_TAG					0x0badbeef
> -
> -
> -//====================================
> -// Internal variable for module
> -//====================================
> +/*
> + * ====================================
> + * wb35rx_s.h --
> + * ====================================
> + */
> +
> +/*Definition for this module used */
> +#define MAX_USB_RX_BUFFER		4096	/* This parameter must be 4096 */
> +#define MAX_USB_RX_BUFFER_NUMBER	ETHERNET_RX_DESCRIPTORS	/* Maximum 254, 255 is RESERVED ID */
> +#define RX_INTERFACE			0	/* Interface 1 */
> +#define RX_PIPE				2	/* Pipe 3 */
> +#define MAX_PACKET_SIZE			1600	/* 1568	 8 + 1532 + 4 + 24(IV EIV MIC ICV CRC) for check DMA data */
> +#define RX_END_TAG			0x0badbeef
> +
> +
> +/*
> + * ====================================
> + * Internal variable for module
> + * ====================================
> + */
>  struct wb35_rx {
> -	u32			ByteReceived;// For calculating throughput of BulkIn
> -	atomic_t		RxFireCounter;// Does Wb35Rx module fire?
> +	u32	ByteReceived; /* For calculating throughput of BulkIn */
> +	atomic_t RxFireCounter; /* Does Wb35Rx module fire? */
>  
> -	u8	RxBuffer[ MAX_USB_RX_BUFFER_NUMBER ][ ((MAX_USB_RX_BUFFER+3) & ~0x03 ) ];
> -	u16	RxBufferSize[ ((MAX_USB_RX_BUFFER_NUMBER+1) & ~0x01) ];
> -	u8	RxOwner[ ((MAX_USB_RX_BUFFER_NUMBER+3) & ~0x03 ) ];//Ownership of buffer  0: SW 1:HW
> +	u8	RxBuffer[MAX_USB_RX_BUFFER_NUMBER][((MAX_USB_RX_BUFFER + 3) & ~0x03)];
> +	u16	RxBufferSize[((MAX_USB_RX_BUFFER_NUMBER + 1) & ~0x01)];
> +	u8	RxOwner[((MAX_USB_RX_BUFFER_NUMBER + 3) & ~0x03)]; /* Ownership of buffer 0:SW 1:HW */
>  
> -	u32	RxProcessIndex;//The next index to process
> +	u32	RxProcessIndex; /* The next index to process */
>  	u32	RxBufferId;
>  	u32	EP3vm_state;
>  
> -	u32	rx_halt; // For VM stopping
> +	u32	rx_halt;	/* For VM stopping */
>  
>  	u16	MoreDataSize;
>  	u16	PacketSize;
>  
> -	u32	CurrentRxBufferId; // For complete routine usage
> +	u32	CurrentRxBufferId; /* For complete routine usage */
>  	u32	Rx3UrbCancel;
>  
> -	u32	LastR1; // For RSSI reporting
> -	struct urb *				RxUrb;
> -	u32		Ep3ErrorCount2; // 20060625.1 Usbd for Rx DMA error count
> +	u32	LastR1; /* For RSSI reporting */
> +	struct	urb *RxUrb;
> +	u32	Ep3ErrorCount2; /* Usbd for Rx DMA error count */
>  
> -	int		EP3VM_status;
> -	u8 *	pDRx;
> +	int	EP3VM_status;
> +	u8	*pDRx;
>  };

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
