Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab1BYP3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:29:31 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:47844 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab1BYP3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:29:30 -0500
Message-ID: <4D67CAD7.7060408@msgid.tls.msk.ru>
Date: Fri, 25 Feb 2011 18:29:27 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: Ben Hutchings <bhutchings@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugene@redhat.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: module loading with CAP_NET_ADMIN
References: <20110224151238.GA16916@albatros> <1298565265.2613.16.camel@bwh-desktop> <20110225123023.GA8776@albatros>
In-Reply-To: <20110225123023.GA8776@albatros>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

25.02.2011 15:30, Vasiliy Kulikov wrote:
> On Thu, Feb 24, 2011 at 16:34 +0000, Ben Hutchings wrote:
>> On Thu, 2011-02-24 at 18:12 +0300, Vasiliy Kulikov wrote:
>>> My proposal is changing request_module("%s", name) to something like
>>> request_module("netdev-%s", name) inside of dev_load() and adding
>>> aliases to related drivers.

It is not the kernel patching which we should worry about, kernel
part is trivial.

What is not trivial is to patch all the systems out there who
autoloads network drivers based on /etc/modprobe.d/network-aliases.conf
(some local file), ie, numerous working setups which already
uses this mechanism since stone age.  And patching these is
not trivial at all, unfortunately.

Somewhat weird setups (one can load the modules explicitly, and
nowadays this all is handled by udev anyway), but this change
will break some working systems.

Maybe the cost (some pain for some users) isn't large enough
but the outcome is good, and I think it _is_ good, but it needs
some wider discussion first, imho.

I can't think of a way to handle this without breaking stuff.

Thanks!

/mjt
