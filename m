Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2JVXQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 19:16:56 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:48062
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab2JVXQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 19:16:55 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: 3.7 RC1 
Date: Mon, 22 Oct 2012 16:37:45 -0700
Message-Id: <1350949065-24655-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While testing 3.7 RC1 I discovered that invoking the function orderly_poweroff()
from an interrupt context will trigger an ASSERT(). This was not the case till
recently. The comment preceding the orderly_poweroff() function claims that this
function can be invoked from any context and in the current Hyper-V util driver,
we support host-driven orderly shut down of the guest by invoking this
orderly_poweroff() function in the context of the message callback. This code has
been working for a very long time and it is broken now. Is my assumption that
orderly_poweroff() could be invoked from the interrupt context a wrong assumption?

Regards,

K. Y
