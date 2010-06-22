Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab0FVC5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 22:57:42 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46951 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0FVC5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 22:57:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=cGy5Gs7rHxzi85EkAXcVhKmxAg+yIHf0EX0ZIwj12jAdSG/9BodUjs5D0phalJrRAd
         30QI+Szyihoq7fDQ1eLjey41kVRiLhA+KiedBAX6Yv72HBHyALEbjZTGaqHDGhrvB47C
         AYVdSicsxiETabvG8neqRgfxJzIQ6P3DJAUzs=
MIME-Version: 1.0
Date: Mon, 21 Jun 2010 20:57:40 -0600
Message-ID: <AANLkTilCW2iqsNaWM9NYIomy8OxGC9jG40KpLcKMYTqL@mail.gmail.com>
Subject: 2.6.34 Crash in dmaengine_put()
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If someone sets the IFF_UP flags in the netdev structure without going
through ifup userspace stuff, during unregister of the the netdev
the dmaengine-put code will decrement the reference counter negative,
and crash at BUG! in the driver/dma/dmaengine.c code.  This seems
busted.

Jeff
