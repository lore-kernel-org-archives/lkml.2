Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab1I2Ods (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:33:48 -0400
Received: from shutemov.name ([188.40.19.243]:43083 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308Ab1I2Odr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:33:47 -0400
Date: Thu, 29 Sep 2011 17:33:46 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [004/244] sfi: table irq 0xFF means no interrupt
Message-ID: <20110929143346.GA7357@shutemov.name>
References: <20110928220225.GA27128@kroah.com>
 <20110928220125.665499011@clark.kroah.org>
 <20110929102100.GA6378@shutemov.name>
 <20110929141827.GC3002@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929141827.GC3002@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 07:18:27AM -0700, Greg KH wrote:
> On Thu, Sep 29, 2011 at 01:21:00PM +0300, Kirill A. Shutemov wrote:
> > On Wed, Sep 28, 2011 at 02:59:28PM -0700, Greg KH wrote:
> > > 3.0-stable review patch.  If anyone has any objections, please let us know.
> > > 
> > > ------------------
> > > 
> > > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > 
> > > commit a94cc4e6c0a26a7c8f79a432ab2c89534aa674d5 upstream.
> > > 
> > > According to the SFI specification irq number 0xFF means device has no
> > > interrupt or interrupt attached via GPIO.
> > > 
> > > Currently, we don't handle this special case and set irq field in
> > > *_board_info structs to 255.  It leads to confusion in some drivers.
> > > Accelerometer driver tries to register interrupt 255, fails and prints
> > > "Cannot get IRQ" to dmesg.
> > > 
> > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > Please, take this as well:
> > 
> > http://lkml.org/lkml/2011/9/14/40
> 
> Is that patch in Linus's tree?

No, it isn't.

Do not apply "sfi: table irq 0xFF means no interrupt" in this case. It
breaks kexec. Better to take both patches into next stable release.

-- 
 Kirill A. Shutemov
