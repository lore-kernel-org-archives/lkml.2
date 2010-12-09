Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab0LITFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:05:45 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:46341 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176Ab0LITFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:05:44 -0500
Message-ID: <4D012844.3020009@euromail.se>
Date: Thu, 09 Dec 2010 20:04:36 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Jarod Wilson <jarod@redhat.com>,
        =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Subject: Re: [RFC] Input: define separate EVIOCGKEYCODE_V2/EVIOCSKEYCODE_V2
References: <20101209093948.GD8821@core.coreip.homeip.net>
In-Reply-To: <20101209093948.GD8821@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PQlnI-0001WX-Bj.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PQlnI-0001WX-Bj 1db4dcc398b6be6962e49ac9a411548b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 10:39 AM, Dmitry Torokhov wrote:

> The desire to keep old names for the EVIOCGKEYCODE/EVIOCSKEYCODE while
> extending them to support large scancodes was a mistake. While we tried
> to keep ABI intact (and we succeeded in doing that, programs compiled
> on older kernels will work on newer ones) there is still a problem with
> recompiling existing software with newer kernel headers.
> 
> New kernel headers will supply updated ioctl numbers and kernel will
> expect that userspace will use struct input_keymap_entry to set and
> retrieve keymap data. But since the names of ioctls are still the same
> userspace will happily compile even if not adjusted to make use of the
> new structure and will start miraculously fail in the field.
> 
> To avoid this issue let's revert EVIOCGKEYCODE/EVIOCSKEYCODE definitions
> and add EVIOCGKEYCODE_V2/EVIOCSKEYCODE_V2 so that userspace can explicitly
> select the style of ioctls it wants to employ.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---


Would the header change suffice in itself? Either way, also checked that the
bugfixes following the original patch is still in effect, so looks ok to me.

Henrik
