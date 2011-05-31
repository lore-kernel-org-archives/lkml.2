Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab1EaIk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:40:58 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:46664 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1EaIkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:40:55 -0400
Date: Tue, 31 May 2011 10:40:53 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq@rere.qmqm.pl>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH v3] 8250_pci: add -ENODEV code for Intel EG20T PCH
Message-ID: <20110531084052.GA13972@rere.qmqm.pl>
References: <1306808559-4246-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1306808559-4246-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 11:22:39AM +0900, Tomoya MORINAGA wrote:
> Intel EG20T PCH has UART device which is compatible with 8250.
> Currently, with general configuration, the PCH UART driver is not loaded but
> 8250 standard driver is loaded.
> Therefore, in case of using PCH UART driver, need to disable 8250 pci function.
> However, this procedure is not best solution.
> This patch, in 8250_pci, if the device is the PCH or the family IOH,
> '-ENODEV' is returned.
> As a result, disabling 8250-pci processing becomes unnecessary.
[...]
> +static int pci_eg20tpch_init(struct pci_dev *dev)
> +{
> +	return -ENODEV;
> +}

You could name it just return_ENODEV() or similar and then while looking
at the device-id table you would know right away what this entry is doing.

Best Regards,
Micha³ Miros³aw
