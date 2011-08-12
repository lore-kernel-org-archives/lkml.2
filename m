Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab1HLQSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:18:22 -0400
Received: from sous-sol.org ([216.99.217.87]:56252 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751854Ab1HLQSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:18:20 -0400
Date: Fri, 12 Aug 2011 09:18:05 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Jun.Kondo" <jun.kondo@ctc-g.co.jp>
Cc: linux-kernel@vger.kernel.org,
        "omega-g1@ctc-g.co.jp" <omega-g1@ctc-g.co.jp>, notsuki@redhat.com,
        "Kozaki, Motokazu" <motokazu.kozaki@hp.com>,
        Hajime Taira <htaira@redhat.com>, netdev@vger.kernel.org
Subject: Re: Request for Redhat
Message-ID: <20110812161805.GI9766@sequoia.sous-sol.org>
References: <4E450C8F.4030009@ctc-g.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E450C8F.4030009@ctc-g.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jun,

* Jun.Kondo (jun.kondo@ctc-g.co.jp) wrote:
> CTC had the following demand;
> 
> 1. to ensure high throughput from the beginning of
> tcp connection at normal times by acquiring large
> default transmission buffer value
> 
> 2. to limit the block time of the write in order to
> prevent the timeout of upper layer applications
> even when the connection has low throughput, such
> as low rate streaming

Make sure you include network developers (netdev@vger.kernel.org Cc'd)
on networking related patches.

You'll find some helpful information regarding the email format for
submitting patches here:
  http://www.kernel.org/doc/Documentation/SubmittingPatches

Improving your Subject: and fixing the patch level for your diff come
to mind immediately.

> --- sock.h 2011-04-14 14:58:03.000000000 +0900
> +++ sock.h.mod 2011-04-21 15:30:07.000000000 +0900
> @@ -434,9 +434,12 @@
> /*
> * Compute minimal free write space needed to queue new packets.
> */
> +
> +extern int sysctl_tcp_lowat;
> +
> static inline int sk_stream_min_wspace(struct sock *sk)
> {
> - return sk->sk_wmem_queued / 2;
> + return sk->sk_wmem_queued >> sysctl_tcp_lowat;
> }

Also, this patch appears to be against an old tree (I assume the RHEL
5 tree).  To be considered upstream, you need to generate a diff against
the upstream tree.  And considering all that's changed since 2.6.18, it
would be useful to verify you still have the issue in a current upstream
Linux tree.

Alternatively, you may consider using Red Hat's Bugzilla to contact RH
engineers for help and guidance.

Good luck.

thanks,
-chris
