Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab2EBSO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:14:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36113 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab2EBSOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:14:55 -0400
Date: Wed, 2 May 2012 20:14:35 +0200
From: Andi Shyti <andi.shyti@gmail.com>
To: Bryan Freed <bfreed@chromium.org>
Cc: Peter Huewe <peter.huewe@infineon.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>, tpmdd@selhorst.net,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Luigi Semenzato <semenzato@google.com>
Subject: Re: [PATCH] CHROMIUM: tpm: tpm_tis_i2c: Lock the I2C adapter for a
 sequence of requests.
Message-ID: <20120502181435.GF16981@andi>
Mail-Followup-To: Bryan Freed <bfreed@chromium.org>,
	Peter Huewe <peter.huewe@infineon.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>, tpmdd@selhorst.net,
	tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	Olof Johansson <olof@lixom.net>,
	Luigi Semenzato <semenzato@google.com>
References: <1335967293-7728-1-git-send-email-peter.huewe@infineon.com>
 <1335967416-7564-1-git-send-email-peter.huewe@infineon.com>
 <20120502151734.GD16981@andi>
 <CAEYUcX0jBHasvcdLefR0fOGrVPaDw3pqzfQ_8_JGXHSPQHW7Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEYUcX0jBHasvcdLefR0fOGrVPaDw3pqzfQ_8_JGXHSPQHW7Ew@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

> > try to have a look to the i2c_smbus* function, you could avoid
> > lot of code
On Wed, May 02, 2012 at 10:25:09AM -0700, Bryan Freed wrote:
> (Sorry for resending...)
> 
> Andi, it is not clear what i2c_smbus_* functions in particular will
> improve upon this change.
> 
> All i2c_smbus_* functions go through i2c_smbus_xfer() which at some
> point will i2c_lock_adapter() for each request.
> This is true for adapters that support SMBUS (where the lock occurs
> directly in i2c_smbus_xfer()) or just I2C (where the lock occurs in
> i2c_transfer() called through i2c_smbus_xfer_emulated()).
> 
> The goal of this change is for the tpm_tis_i2c driver to be able to
> lock an adapter over the duration of several I2C requests.
> Presumably, that is why i2c_lock_adapter() is exported.

the i2c_smbus_* functions will not improve anything to the
driver, it will increase the readability and it will allow you to
do the same stuff with less code.
All the i2c communication implementation you wrote here, is
already written in the i2c-core.c file.

Andi
