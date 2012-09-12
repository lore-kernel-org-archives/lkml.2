Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494Ab2ILQnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:43:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51558 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab2ILQnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:43:50 -0400
Message-ID: <5050BBC1.1090207@gmail.com>
Date: Wed, 12 Sep 2012 18:43:45 +0200
From: Zdenek Kaspar <zkaspar82@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.7) Gecko/20120829 Thunderbird/10.0.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: make tar*-pkg considered dangerous
References: <20120912031646.GV16230@one.firstfloor.org>
In-Reply-To: <20120912031646.GV16230@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 05:16 AM, Andi Kleen wrote:
> 
> Hi,
> 
> We've had some incidents with people destroying Fedore 17 installs
> (to the point of reinstall) by installing a kernel tarball generated with 
> make tar*-pkg
> 
> The problem is that the tarball includes /lib/{modules,firmware},
> but on FC17 /lib is a symlink. tar when it unpacks the tarball
> replaces the symlink with the directory. So they end up
> with a /lib which only contains the new kernel files, but nothing else,
> 
> And then the system doesn't boot anymore.
> 
> I'm not sure there is a good fix for this. I don't know of a way to
> convince tar to not do that. And putting everything into /usr 
> would be very incompatible.
> 
> Disable these make targets or add warnings?  If disabling people should
> use rpms or dpkgs instead?
> 
> -Andi
> 

I dont use the dpkg/rpm variants myself, but unpack with -h should be
enough?

HTH, Z.
