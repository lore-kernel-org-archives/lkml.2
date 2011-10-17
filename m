Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1JQIxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 04:53:14 -0400
Received: from lnx500.hrz.tu-darmstadt.de ([130.83.156.225]:54499 "EHLO
	lnx500.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577Ab1JQIxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 04:53:12 -0400
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20123.60660.896589.761967@elektron.ikp.physik.tu-darmstadt.de>
Date: Mon, 17 Oct 2011 10:53:08 +0200
To: linux-kernel@vger.kernel.org
Subject: Re: How to blacklist a usb_storage device from attach to the
   usb_storage module
In-Reply-To: <20121.41239.485545.656633@elektron.ikp.physik.tu-darmstadt.de>
References: <20121.41239.485545.656633@elektron.ikp.physik.tu-darmstadt.de>
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.10.17.84514
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Uwe" == Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de> writes:

    Uwe> Hello, The STxxDiscovery Modules are affordable small boards with
...
    Uwe> blacklisting there will need time to propagate to the kernel tree
    Uwe> and back to the distributions. So a way to runtime blacklist is
    Uwe> needed too.

To answer my own question, at least partial, with and udev Rule like
SUBSYSTEM=="usb", ACTION=="add", ATTRS{idVendor}=="0483", \
ATTRS{idProduct}=="3744", DRIVER=="usb-storage", \
RUN+="/bin/sh -c 'echo -n %k> %S%p/driver/unbind'"

as the first rule for the device, the device still binds to the driver but
as first action is unbinded.

Should such a device still be blacklisted in the kernel somehow?

-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
