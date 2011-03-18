Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab1CRPus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:50:48 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:48289 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756694Ab1CRPun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:50:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IuJFVwVIjkNtg4pe9H0I/MIWzICWoHW9LRenzx9JB8d3THsZdpX3UCqQ3M/cXYLQv+wfUlXU+5pI9+ugPORi4RwQrdgx83GBiUz9rnsDGLaOl+IMRLZXbbydlzRaaJmJ;
Date: Fri, 18 Mar 2011 08:50:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Cc: <linux-i2c@vger.kernel.org>, <arnd@arndb.de>, <sameo@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <hthebaud@insidefr.com>,
        <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Message-Id: <20110318085033.9bea6dc9.rdunlap@xenotime.net>
In-Reply-To: <1300444824-13713-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
	<1300444824-13713-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011 11:40:24 +0100 Waldemar Rymarkiewicz wrote:

> Add new driver for MicroRead NFC chip connected to i2c bus.
> 
> See Documentation/nfc/nfc-microread.txt.
> 
> Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
> ---
>  Documentation/nfc/nfc-microread.txt |   46 ++++
>  drivers/nfc/Kconfig                 |   10 +
>  drivers/nfc/Makefile                |    1 +
>  drivers/nfc/microread.c             |  465 +++++++++++++++++++++++++++++++++++
>  include/linux/nfc/microread.h       |   31 +++
>  5 files changed, 553 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/nfc/nfc-microread.txt
>  create mode 100644 drivers/nfc/microread.c
>  create mode 100644 include/linux/nfc/microread.h
> 
> diff --git a/Documentation/nfc/nfc-microread.txt b/Documentation/nfc/nfc-microread.txt
> new file mode 100644
> index 0000000..e15c49c
> --- /dev/null
> +++ b/Documentation/nfc/nfc-microread.txt
> @@ -0,0 +1,46 @@
> +Kernel driver for Inside Secure MicroRead Near Field Communication chip
> +
> +General
> +-------
> +
> +microread is the RF chip that uses Near Field Communication (NFC) for proximity
> +transactions and interactions.
> +
> +Please visit Inside Secure webside for microread specification:

                              website (or web site)

> +http://www.insidesecure.com/eng/Products/NFC-Products/MicroRead
> +
> +
> +The Driver
> +----------
> +
> +The microread driver can be found under drivers/nfc/microread.c and it's
> +compiled as a module named "microread".
> +
> +The driver supports i2c interface only.
> +
> +The userspace application can use /dev/microread device to control the chip by
> +HCI messages. In a typical scenario application will open() /dev/microread,
> +reset the chip useing ioctl() interface then poll() the device to check if

                  using

> +writing/reaing is possible.Finally, will read/write data (HCI) from/to the chip.

           reading is possible. Finally, it will

> +
> +Note that only one application can use the /dev/microread at the time.
> +
> +The driver waits for microread chip interrupt which occures if there are some

                                                       occurs

> +data to be read. Then, poll() will indicate that fact to the userspace.
> +
> +The application can use ioctl(MICROREAD_IOC_RESET)to reset the hardware.

                                              _RESET) to reset

> +
> +
> +Platform Data
> +-------------
> +
> +The below platform data should be set when configuring board.
> +
> +struct microread_nfc_platform_data {
> +	unsigned int rst_gpio;
> +	unsigned int irq_gpio;
> +	unsigned int ioh_gpio;
> +	int (*request_hardware) (struct i2c_client *client);
> +	void (*release_hardware) (void);
> +};
> +


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
