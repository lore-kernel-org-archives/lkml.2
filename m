Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab0D3Uaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:30:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57119 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab0D3Ua2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:30:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 04/14] vc: Locking clean up
Date: Fri, 30 Apr 2010 22:30:22 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100401155513.8882.54006.stgit@localhost.localdomain> <20100401160451.8882.30559.stgit@localhost.localdomain>
In-Reply-To: <20100401160451.8882.30559.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004302230.22358.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19kLfeFwmTiohzlVNMyJssh8eFAcoTtPTqYT5t
 wlr4F1fBzco8BLBheQTuyyEcQgsmSD3qqD99B7bKPR/tyzVJp4
 lgMi8QBl7wsyxOoOh/UNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010 18:04:59 Alan Cox wrote:
> @@ -282,7 +282,12 @@ static inline unsigned short *screenpos(struct vc_data *vc, int offset, int view
>  
>  static inline void scrolldelta(int lines)
>  {
> +       lock_kernel();
> +       /* FIXME */
> +       /* scrolldelta needs some kind of consistency lock, but the BKL was
> +          and still is not protecting versus the scheduled back end */
>         scrollback_delta += lines;
> +       unlock_kernel();
>         schedule_console_callback();
>  }
>  

This one triggered a might_sleep() warning in _lock_kernel(), because
it's called from the keyboard interrupt.

	Arnd
