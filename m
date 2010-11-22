Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab0KVMAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:00:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43068 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab0KVMAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:00:41 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Govindarajan, Sriramakrishnan" <srk@ti.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Clouter <alex@digriz.org.uk>,
        Chris Cordahi <christophercordahi@nanometrics.ca>
Date: Mon, 22 Nov 2010 17:30:09 +0530
Subject: RE: [PATCH v2 4/4] da850-evm: add baseboard UI expander buttons,
 switches and LEDs
Thread-Topic: [PATCH v2 4/4] da850-evm: add baseboard UI expander buttons,
 switches and LEDs
Thread-Index: AcuIADiWe80zCTUaQiqwSyDccpMpiACO5LmA
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59302477EB2D8@dbde02.ent.ti.com>
References: <cover.1289835508.git.bengardiner@nanometrics.ca>
	<cover.1289935504.git.bengardiner@nanometrics.ca>
	<d6d59b4a3c34149008f3681e0d6106efa15f354d.1289935504.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EAA89@dbde02.ent.ti.com>
 <AANLkTike4sRvptEe9PXLT2u+SrFMOpNC6pvLPSzBfVOX@mail.gmail.com>
In-Reply-To: <AANLkTike4sRvptEe9PXLT2u+SrFMOpNC6pvLPSzBfVOX@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Fri, Nov 19, 2010 at 21:10:50, Ben Gardiner wrote:

> >> [...]
> >
> > How does gpio_request prevent sysfs control?
>
> To obtain access to a gpio through the sysfs interface the user must
> first write the gpio number to 'export'. When the gpio has been
> gpio_request()'d the result of writing to 'export' is nothing; whereas
> writing to export would normally result in the appearance of a named
> gpio line alongside 'export'.
>
>  I hope the following commands and their output illustrate my point:
>
> $ cd /sys/class/gpio/
> $ ls
> export       gpiochip128  gpiochip160  gpiochip64   unexport
> gpiochip0    gpiochip144  gpiochip32   gpiochip96
> $ echo 160 > export
> $ ls
> export       gpiochip128  gpiochip160  gpiochip64   unexport
> gpiochip0    gpiochip144  gpiochip32   gpiochip96
> $ echo 163 > export
> $ ls
> export       gpiochip128  gpiochip160  gpiochip64   tp_22
> gpiochip0    gpiochip144  gpiochip32   gpiochip96   unexport

Thanks for the explanation. I should have probably asked
earlier, why do we need to prevent sysfs access of
deep sleep enable and sw reset pins? We don't seem to be
using them in the kernel either.

Thanks,
Sekhar

