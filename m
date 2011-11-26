Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1KZRaV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 12:30:21 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63335 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab1KZRaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 12:30:20 -0500
Date: Sat, 26 Nov 2011 18:30:08 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-iio@vger.kernel.org, greg@kroah.com, linux-kernel@vger.kernel.org
Cc: federico.vaga@gmail.com, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: [RFC PATCH 0/7] Introducing ZIO, a new I/O framework
Message-ID: <cover.1322328073.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This RFC patch-set introduces the ZIO framework for input/output,
which will be used in the new series of drivers by the BE-CO-HT
group at CERN.

The use-case it is meant to cover is very fast I/O with
hardware-provided timestamps.  The first production driver we will
support is a 100Ms/s 4-channel 14-bit ADC (developed on ohwr: see
http://www.ohwr.org/projects/fmc-adc-100m14b4cha ).  We need similar
bandwidth on output.

The synchronization engine of that FMC card and other ones is going to
be White Rabbit (http://www.ohwr.org/projects/white-rabbit).

Currently, the patch-set includes one example driver (zio-zero)
that behaves like /dev/zero and /dev/urandom. Other drivers will
come soon, both demo and real hardware.

Slides for a tutorial on the design ideas are online here:
http://www.ohwr.org/attachments/881/zio-111123.pdf

A list of pending issues and development plans is online at:
http://www.ohwr.org/projects/zio/wiki/Todo

/alessandro

Alessandro Rubini (5):
  Documentation: add docs for drivers/zio
  include/linux: add headers for drivers/zio
  drivers/zio: add triggers and buffers
  drivers/zio: add user-space tool zio-dump
  zio: insert in Kbuild so it is actually compiled

Federico Vaga (2):
  drivers/zio: core files for the ZIO input/output framework
  drivers/zio: add the zio-zero device driver

 Documentation/zio/00-INDEX            |   10 +
 Documentation/zio/buffer.txt          |  114 +++
 Documentation/zio/device.txt          |   69 ++
 Documentation/zio/modules.txt         |   45 +
 Documentation/zio/trigger.txt         |  128 +++
 drivers/Kconfig                       |    2 +
 drivers/Makefile                      |    1 +
 drivers/zio/Kconfig                   |   12 +
 drivers/zio/Makefile                  |   10 +
 drivers/zio/README                    |  105 +++
 drivers/zio/buffers/Makefile          |    1 +
 drivers/zio/buffers/zio-buf-kmalloc.c |  273 +++++++
 drivers/zio/drivers/Makefile          |    1 +
 drivers/zio/drivers/zio-zero.c        |   87 ++
 drivers/zio/triggers/Makefile         |    2 +
 drivers/zio/triggers/zio-trig-irq.c   |  203 +++++
 drivers/zio/triggers/zio-trig-timer.c |  193 +++++
 drivers/zio/zio-cdev.c                |  498 ++++++++++++
 drivers/zio/zio-dump.c                |  196 +++++
 drivers/zio/zio-sys.c                 | 1423 +++++++++++++++++++++++++++++++++
 include/linux/zio-buffer.h            |  246 ++++++
 include/linux/zio-sysfs.h             |  122 +++
 include/linux/zio-trigger.h           |   99 +++
 include/linux/zio.h                   |  244 ++++++
 24 files changed, 4084 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/zio/00-INDEX
 create mode 100644 Documentation/zio/buffer.txt
 create mode 100644 Documentation/zio/device.txt
 create mode 100644 Documentation/zio/modules.txt
 create mode 100644 Documentation/zio/trigger.txt
 create mode 100644 drivers/zio/Kconfig
 create mode 100644 drivers/zio/Makefile
 create mode 100644 drivers/zio/README
 create mode 100644 drivers/zio/buffers/Makefile
 create mode 100644 drivers/zio/buffers/zio-buf-kmalloc.c
 create mode 100644 drivers/zio/drivers/Makefile
 create mode 100644 drivers/zio/drivers/zio-zero.c
 create mode 100644 drivers/zio/triggers/Makefile
 create mode 100644 drivers/zio/triggers/zio-trig-irq.c
 create mode 100644 drivers/zio/triggers/zio-trig-timer.c
 create mode 100644 drivers/zio/zio-cdev.c
 create mode 100644 drivers/zio/zio-dump.c
 create mode 100644 drivers/zio/zio-sys.c
 create mode 100644 include/linux/zio-buffer.h
 create mode 100644 include/linux/zio-sysfs.h
 create mode 100644 include/linux/zio-trigger.h
 create mode 100644 include/linux/zio.h

-- 
1.7.7.2
