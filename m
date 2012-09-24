Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab2IXN4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:56:16 -0400
Received: from science.horizon.com ([71.41.210.146]:59576 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754695Ab2IXN4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:56:15 -0400
Date: 24 Sep 2012 09:56:14 -0400
Message-ID: <20120924135614.24704.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mpn@google.com, vda.linux@googlemail.com
Subject: Re: [PATCH 2/4] lib: vsprintf: Optimize division by 10000
Cc: hughd@google.com, linux-kernel@vger.kernel.org
In-Reply-To: <xa1tfw67d24j.fsf@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Nazarewicz <mpn@google.com> wrote:
> Didn't some SPARCs have 32x32->32 multiply?  I remember reading some
> rant from a GMP developer about how SPARC is broken that way.

SPARCv9 only has 64x64->64; there's no 128-bit result version.
That cuts large-integer math speed by a factor of 4 (very
crude approximation), to the same speed as 32x32->64.

SPARCv8 UMUL puts the high half of the 64-bit result into the Y
register, and SPARCv7 has a multiply-step instruction (MULScc) which
does likewise.
