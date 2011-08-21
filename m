Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1HUBFr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 21:05:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab1HUBFq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 21:05:46 -0400
MIME-Version: 1.0
In-Reply-To: <4E4FA6D8.7030407@redhat.com>
References: <1313806667-30495-1-git-send-email-liubo2009@cn.fujitsu.com> <4E4FA6D8.7030407@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 20 Aug 2011 18:04:51 -0700
Message-ID: <CA+55aFzm67yfdnwu9ou6X6zf05DyiGvCD0ci8vZM97W+B_HMoQ@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: use do_div to avoid compile errors on 32bit box
To: Josef Bacik <josef@redhat.com>
Cc: Liu Bo <liubo2009@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, jwboyer@gmail.com, linux-btrfs@vger.kernel.org,
        chris.mason@oracle.com, dave@jikos.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 5:21 AM, Josef Bacik <josef@redhat.com> wrote:
>
> I think Linus was less complaining about how you're dividing here and
> more about the fact that you are.  A divide by 2 is the same as a >> 1.
>  I'll send a patch to fix this.  Thanks,

Indeed. A single-bit 64-bit "double shift" may be a few cycles, but
it's still pretty damn cheap. Especially when compared to a 64x32 bit
divide. We absolutely don't want to do "do_div()" in order to divide
by the constant 2.

                     Linus
