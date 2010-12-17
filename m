Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0LQUQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:16:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42405 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab0LQUQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:16:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=L21KY0fqrhvvh93PG+Q1pbUVgP/0S2yPkHZsLEhlmhVBiopFzfpx/w84odqi/h+/Ff
         p6G6w3dLp51++OrLsw6ct06njJnx6eNs/RX+0C6K3hCuGOK4FxZZOSHhVgRteN/1mLx2
         6utJtyjKEHLusHaD7khqWePO6505nn5weVLZQ=
MIME-Version: 1.0
In-Reply-To: <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
References: <cover.1292512461.git.richard.cochran@omicron.at>
	<880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
Date: Sat, 18 Dec 2010 05:16:52 +0900
Message-ID: <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com>
Subject: Re: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
From: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/10, Richard Cochran <richardcochran@gmail.com> wrote:
> This patch adds a new mode bit into the timex structure. When set, the bit
> instructs the kernel to add the given time value to the current time.
>

The proposed new control mode, ADJ_SETOFFSET, is logically the same as
ADJ_OFFSET with timex.constant == -INFINITY.  So it is possible to do
the same thing without risking forward compatibility.  (I mean by "risking
forward compatibility" that the mode bit 0x0040 may be defined differently
by the upstream maintainer anytime in the future.)
