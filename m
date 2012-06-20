Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab2FTXq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:46:57 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47693 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932191Ab2FTXqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:46:54 -0400
X-Sasl-enc: 0qZb3wKbqNOL+xb/7EbotK+7OK7QfQNZCKBWrGRcNtM5 1340236013
Date: Wed, 20 Jun 2012 20:46:51 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@amd64.org>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
Message-ID: <20120620234651.GD4223@khazad-dum.debian.net>
References: <20120615125240.GD6083@aftab.osrc.amd.com>
 <20120615165231.GA9169@aftab.osrc.amd.com>
 <20120619024639.GB6186@khazad-dum.debian.net>
 <4FDFF27C.5000205@zytor.com>
 <20120619051116.GB31591@aftab.osrc.amd.com>
 <1340093864.21745.6.camel@twins>
 <20120619102250.GA787@aftab.osrc.amd.com>
 <1340101568.21745.37.camel@twins>
 <20120619182228.GA18816@khazad-dum.debian.net>
 <4FE0DF9F.10401@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE0DF9F.10401@zytor.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012, H. Peter Anvin wrote:
> On 06/19/2012 11:22 AM, Henrique de Moraes Holschuh wrote:
> > Even if we have the very early microcode facility, we *still* want the
> > runtime one based on sysfs+request_firmware in order to update microcode
> > without the need for a reboot.
> 
> I am slightly questioning the clause "based on sysfs+request_firmware"
> in the above sentence, but again, not a huge deal either way.

Well, it makes the kernel tell us what (amd/intel/whatever) firmware it
wants, and requires (after patching) a simple echo 1 >foo to activate.  It
is also harmless if activated without updated firmware in place.

/dev/cpu/microcode requires special software (or a dd with bs>=file size),
since it borks if userspace breaks a microcode into two write() syscalls,
and requires detection of the cpu vendor.  Very annoying.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
