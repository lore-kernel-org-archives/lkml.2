Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0GNKaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 06:30:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51033 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab0GNKaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 06:30:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=DQVKuF4F+PzmllqlMLvxVscg5VRsvayejLavHv/pEzmgn7GMBcZXYG8KsPWbAuF6Z0
         0IB9UqnpiY6LbJ0z89w+npgO2WKsqCbkyMtssZglS9CxrUFUAGKR09etWD+ILtaxfToV
         oVq4A61jI8L2hnNjSwiqCh3PnJEr7tNO7MZNc=
Date: Wed, 14 Jul 2010 14:29:51 +0400
From: Dan Kruchinin <dkruchinin@acm.org>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] padata: cpumasks
Message-ID: <20100714142951.22817d0c@leibniz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my third attempt to send padata cpumasks patchset.
The patchset includes fixes of all unclear things Steffen noted in previous two patchsets.
Changes:

1) Make two cpumasks in padata instead of one. The first cpumask is used by parallel workers and
another is used by the workers doing serialization. Two distinguish cpumasks perform to build
configuration where CPUs used by parallel and serial workers aren't intersect. It significantly
improves performance.
Each padata instance now includes notifier chain which can be used by users interested in instance's
cpumask(serial or parallel) change. If one of cpumask is changed an event is generated.

2) Add sysfs primitives to padata. Each padata instance contains kobject which can be embedded to any
proper sysfs hierarchy. Padata kobject can be used to change or show serial or parallel cpumask.

3) Add sysfs representation to pcrypt. Pcrypt now creates /sys/kernel/pcrypt/[pencrypt|pdecrypt] during
module loading phase. pencrypt and pdecrypt directories are represented by kobjects of padata instances
that belongs to pencrypt and pdecrypt respectively. Using this sysfs interface user can change and read
serial and parallel cpumasks of both instances.

-- 
W.B.R.
Dan Kruchinin
