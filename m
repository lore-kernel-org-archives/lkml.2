Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207Ab2JWX6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:58:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51649 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933579Ab2JWX6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:58:19 -0400
Message-ID: <1351033019.7502.66.camel@joe-AO722>
Subject: Re: [PATCH v3 1/6] Add header files and Kbuild plumbing for SI476x
 MFD core
From: Joe Perches <joe@perches.com>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1351017872-32488-2-git-send-email-andrey.smirnov@convergeddevices.net>
References: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net>
	 <1351017872-32488-2-git-send-email-andrey.smirnov@convergeddevices.net>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 23 Oct 2012 15:56:59 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.6.0-0ubuntu3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 11:44 -0700, Andrey Smirnov wrote:
> This patch adds all necessary header files and Kbuild plumbing for the
> core driver for Silicon Laboratories Si476x series of AM/FM tuner
> chips.

[]

> +#ifdef DEBUG
> +#define DBG_BUFFER(device, header, buffer, bcount)			\
> +	do {								\
> +		dev_info((device), header);				\
> +		print_hex_dump_bytes("",				\
> +				     DUMP_PREFIX_OFFSET,		\
> +				     buffer, bcount);			\
> +	} while (0)

maybe just:
	dev_dbg(device, whatever_fmt ": %*ph\n", bcount, buffer);
at each call site


