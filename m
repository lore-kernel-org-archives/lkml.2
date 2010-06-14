Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0FNVeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:34:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46777 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab0FNVeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=A5ZhQuZKRpCxgaU1oNuMI2tsuGIMvKyy86YZUpZRy8R1YDU7u6WV/Q/JsXt/hF1/Ei
         rGQ9Qbo5w6EvZkXrAExCvjyKbgyHsJeyEzmrlDlVMlJ0imjIgqQtTCQScc8P7sFpn8FZ
         wrDrtx9NV2SIGbaiJwhcpluiH6PpQW2rG2muI=
MIME-Version: 1.0
In-Reply-To: <20100614203611.GE369@basil.fritz.box>
References: <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
	<20100518191802.GG25224@aftab>
	<m1k4r0c0y7.fsf@fess.ebiederm.org>
	<20100518222832.GJ22675@basil.fritz.box>
	<m1wrv0zo9q.fsf@fess.ebiederm.org>
	<20100519064619.GA30320@aftab>
	<20100519070919.GA9618@elte.hu>
	<50689ECC-A371-4923-BEBE-1A5A7E5B9D3B@ludd.ltu.se>
	<20100614114906.GG17092@basil.fritz.box>
	<m14oh59y58.fsf@fess.ebiederm.org>
	<20100614203611.GE369@basil.fritz.box>
Date: Mon, 14 Jun 2010 14:34:22 -0700
X-Google-Sender-Auth: B5VddsJzHN0uhQyDZybIV5nT98c
Message-ID: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com>
Subject: Re: Hardware Error Kernel Mini-Summit
From: Tony Luck <tony.luck@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Nils Carlson <nils.carlson@ludd.ltu.se>, Ingo Molnar <mingo@elte.hu>,
       Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 1:36 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Mon, Jun 14, 2010 at 01:06:59PM -0700, Eric W. Biederman wrote:
>> Displaying the fact that ECC is turned on in the hardware is one
>> of the more interesting bits.  That at least allows you to verify
>> that things are working.
>
> There are hundreds to thousands of BIOS level hardware knobs for memory
> configuration (and if you count all BIOS knobs for everything far more)
>
> Why do you want to check a single bit only? (which is actually not
> a single bit but also a lot of different ways to set this)

There was a case mentioned at the collaboration summit
meeting where a BIOS bug mis-reported whether ECC was
enabled - claiming it was on, when in fact it was off.

Error injection could be used to check for another instance
of a lying BIOS (inject an error - make sure it gets counted).
Not as direct as seeing that the right bits are enabled in the
memory controller configuration registers, but still effective.
Perhaps more so as this technique validates different pieces
of the chipset specific code against each other. An EDAC
driver that tells you that ECC is enabled might be lying too,
if it is looking at the wrong bit or the wrong register.

-Tony
