Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2HOHqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 03:46:43 -0400
Received: from luna.vmars.tuwien.ac.at ([128.130.39.29]:52712 "EHLO
	mail.vmars.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2HOHql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 03:46:41 -0400
Message-ID: <502B53D7.8080804@vmars.tuwien.ac.at>
Date: Wed, 15 Aug 2012 09:46:31 +0200
From: Bernhard Froemel <froemel@vmars.tuwien.ac.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH V2 2/2] apple_gmux: Add support for newer hardware
References: <1344898369-4944-1-git-send-email-mjg@redhat.com> <1344898369-4944-2-git-send-email-mjg@redhat.com> <20120814004625.GB18992@thinkpad-t410> <502A5B40.9010303@vmars.tuwien.ac.at> <502A667B.2060100@vmars.tuwien.ac.at> <20120814151543.GD18992@thinkpad-t410> <502A86B7.8010402@vmars.tuwien.ac.at>
In-Reply-To: <502A86B7.8010402@vmars.tuwien.ac.at>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/14/2012 07:11 PM, Bernhard Froemel wrote:
> Need to play around further..
I think I solved the communication problems concerning byte writes to
the gmux device.

This:
http://luna.vmars.tuwien.ac.at/~froemel/rmbp/patch-apple-gmux_v2.txt
works reliable for me (50+ suspend/resume cycles, many brightness
changes) *without* delays.

I looked once more through Apple's original driver and noticed that
their cmd_done waits until bit 1 is set (not cleared!) and also does
the final read from GMUX_PORT_DPM_RADDR only if bit 1 is not set.
Also it seems that in case of byte writes the old interface should be
followed as well (Apple, why?!).

Bernhard


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlArU9cACgkQ6iVUjPs37Jk6iACfWuZ7zpbc1vFLgJR29UroJeL2
HvMAnja8D7/o+aqywr/qRtNrB/o217Ci
=gcjo
-----END PGP SIGNATURE-----
