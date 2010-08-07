Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0HGR4s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 13:56:48 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:36033 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752865Ab0HGR4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 13:56:47 -0400
Subject: Re: make 3.82 fails on powerpc defconfig update [was: Linux 2.6.35]
From: Paul Smith <psmith@gnu.org>
Reply-To: psmith@gnu.org
To: Thomas Backlund <tmb@mandriva.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@ozlabs.org, bug-make@gnu.org
In-Reply-To: <4C5686FF.9010803@mandriva.org>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
	 <4C5686FF.9010803@mandriva.org>
Content-Type: text/plain; charset="us-ascii"
Organization: GNU's Not Unix!
Date: Sat, 07 Aug 2010 13:56:43 -0400
Message-ID: <1281203803.5923.164.camel@homebase>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Identified-User: {678:box531.bluehost.com:madscie1:mad-scientist.us} {sentby:smtp auth 146.115.68.18 authed with paul+mad-scientist.us}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 11:51 +0300, Thomas Backlund wrote:
> BOOT_TARGETS = zImage zImage.initrd uImage zImage% dtbImage%
> treeImage.% cuImage.% simpleImage.%
> 
> Now, I dont know if this is "intended breakage" by the make update, or 
> if the Makefile needs to be updated....

The change is intentional.  Note, though, that this syntax was always
dodgy, even in previous versions of GNU make.

If you wrote it exactly as you did, where all the explicit targets come
first and all the implicit targets come second, then it seems to have
been interpreted correctly.

However, if you did it any other way (for example, put some explicit
targets after the first implicit target) then make would silently throw
away all the targets starting with the first implicit target.

Since the syntax used here wasn't ever described in the documentation,
rather than reworking it as a new feature I decided to follow the docs
and disallow it, and be verbose about the error.

-- 
-------------------------------------------------------------------------------
 Paul D. Smith <psmith@gnu.org>          Find some GNU make tips at:
 http://www.gnu.org                      http://make.mad-scientist.net
 "Please remain calm...I may be mad, but I am a professional." --Mad Scientist

