Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1E0RqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:46:19 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:47592 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab1E0RqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:46:17 -0400
Subject: Re: [PATCH v5 00/21] EVM
From: David Safford <safford@watson.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
In-Reply-To: <20110526201725.GC15959@elf.ucw.cz>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110518172552.6d482c7a.akpm@linux-foundation.org>
	 <20110526060842.GA13933@localhost.ucw.cz>
	 <4DDE80FE.7010005@schaufler-ca.com>
	 <1306433514.24986.26.camel@localhost.localdomain>
	 <20110526183849.GA4563@ucw.cz>
	 <1306439347.3092.89.camel@localhost.localdomain>
	 <20110526201725.GC15959@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 May 2011 13:45:51 -0400
Message-ID: <1306518351.24986.102.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 22:17 +0200, Pavel Machek wrote:

> I suggest you explain the patchset in the emails, then? Everyone here
> seems to be confused... Attack it protects against, and what kind of
> hardware is needed for the protection to be effective?

The white paper is over 15 pages, and it barely scratches the surface.
Every customer has different security threat models and requirements.
Discussing this in general on the mailing list is really hard.

So let's try to simplify this just down to digital signatures in
the cellphone environment, as you state:

> Because AFAICT, file signatures, as proposed, are only useful for
> locking down my cellphone against myself. (That's -- evil).

The proposed digital signatures can enforce authenticity of a file's 
data (IMA-Appraisal with Digital Signature), and of a file's metadata
(EVM with Digital Signature). For most users, enforcing authenticity
of files is a good thing - a user knows that they are running authentic
software signed by their phone manufacturer, and not malicious files
that they, or someone else installed. In this threat model, EVM is 
mainly authenticating the meta-data of a file (owner, mode, LSM label...). 
IMA-Appraisal and EVM are policy driven, so that the owner is free to 
tailor them or turn them off. There are clearly many other use cases for 
digitally signed data and metadata - authenticity is an important 
kernel feature, one which should be done once, done correctly, and 
upstreamed.

You argue that EVM can be abused to lock down your phone against
rooting, but

1. EVM has no control over rooting through the loader, or rooting
   through vulnerabilities in the kernel, or rooting through 
   vulnerabilities in signed applications, or rooting through 
   the adb shell, or rooting in any way I have seen.

2. The real issue with phones is manufacturers who try to prevent you 
   from running the kernel and software of your choice. Locked
   bootloaders are not a technical problem - they are a market
   problem that can only be addressed with market or regulatory
   forces. In some countries, manufacturers are simply not allowed 
   to do such locking.

Blocking signature verification would serve only to punish Linux 
users who care about the authenticity of their files, while doing 
_nothing_ to stop manufacturers from locking their bootloaders.

dave
> 
> 								Pavel

