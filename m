Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab2DNCrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 22:47:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56083 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690Ab2DNCrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 22:47:12 -0400
X-Sasl-enc: Jtm9GftV8L/8vNQ2Zi2azjTFJ4hcH3TFZ+WCTc8jMRbF 1334371631
Date: Fri, 13 Apr 2012 23:47:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Paul Moore <paul@paul-moore.com>
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        libseccomp-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: ANN: libseccomp
Message-ID: <20120414024708.GB10926@khazad-dum.debian.net>
References: <1540670.AFBi1SpGoi@sifl>
 <CABqD9haXLBDxEkC3+3AN4d4PDVYE-JrqH4P6iTJ95mqYxoR=yA@mail.gmail.com>
 <5076094.qra9nCCzS0@sifl>
 <9270063.OgsgoBpmh0@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9270063.OgsgoBpmh0@sifl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012, Paul Moore wrote:
> the seccomp filter into the kernel.  By default libseccomp attempts to set 
> NO_NEW_PRIVS but does not fail if prctl(NO_NEW_PRIVS) returns with an error; 

Isn't that dangerous in non-obvious ways, as in it can actually
cause/activate/enable/open security issues on priviledged processes that
don't expect whatever filtering seccomp will subject them to?

Maybe it would be best if libseccomp were to (by default) bomb out with
an error if prctl(NO_NEW_PRIVS) fails?  Defaults are important, as
they're what people _who don't know any better_ are likely to use.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
