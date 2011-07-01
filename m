Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1GAD77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 23:59:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:40876 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab1GAD76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 23:59:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=xh2/GR/GEOcoqdBLHNjeHClGVDXydpYShs5G59TkbCrbDLD6JlvE6yq9xOUGrV0Rc
	5GNZ3m/WAFiypiPyOqJhA==
MIME-Version: 1.0
In-Reply-To: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
Date: Thu, 30 Jun 2011 20:59:46 -0700
X-Google-Sender-Auth: -QpA_Rlo-EH3ai29wbc1gp2GrYs
Message-ID: <CAN_12A9pWNTjetV2wDzhO8OTopECC78b38zBxjku+gpR4QwFoA@mail.gmail.com>
Subject: Re: [PATCH 01/11] misc: inv_mpu primary header file and README file.
From: Chris Wolfe <cwolfe@chromium.org>
To: Nathan Royer <nroyer@invensense.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 7:18 PM, Nathan Royer <nroyer@invensense.com> wrote:
> The mpu3050 has an i2c master interface designed to control an accelerometer
> and a Digital Motion Processor (DMP) used to perform sensor fusion on the
> gyroscope and accelerometer.  This data is then read out of the mpu3050 fifo
> and sent to userspace for distribution and optional propritary processing, such
> as fusion with a compass to produce a 9 axis quaternion.

Sorry, just took a quick pass so I may be missing changes. Is this
driver to the stage where someone can practically initialize the 3050
and read low-level data without having the InvenSense MPL already
installed? (and without basically doing I2C reads and writes from
userspace)

As Greg K-H pointed out, IIO provides a lot of the support code for
this kind of driver. Have a look at drivers/staging/iio/imu and the
sibling directories. They provide a framework for reporting the
low-level data in a standard fashion, and some extra attributes to
load the DMP firmware would be easy to add.

I'm disconnected over the weekend, but will touch base with you and
Mike Housholder on Tuesday. Getting this upstream would be great, so
we ought to share notes.

Chris
