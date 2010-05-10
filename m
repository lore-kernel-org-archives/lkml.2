Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0EJNPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 09:15:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59303 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab0EJNPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 09:15:50 -0400
Date: Mon, 10 May 2010 14:15:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: Re: [PATCH] Handle instruction cache maintenance fault properly
Message-ID: <20100510131519.GB7796@n2100.arm.linux.org.uk>
References: <AANLkTikIbI6hKoYSZlo6QDlyi2Qjxg287i-ilHpz1FF9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikIbI6hKoYSZlo6QDlyi2Qjxg287i-ilHpz1FF9@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 04:07:57PM +0300, Kirill A. Shutemov wrote:
> Between "clean D line..." and "invalidate I line" operations in
> v7_coherent_user_range(), the memory page may get swapped out.
> And the fault on "invalidate I line" could not be properly handled
> causing the oops.

You have to be very careful when doing this kind of change - you need to
review the behaviour of previous ARMs to ensure that you don't throw the
CPU into an infinite loop when an "external abort on linefetch" occurs.

With older CPUs, an "external abort on linefetch" is most probably fatal
to the process and can never be recovered.
