Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab0GCPVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 11:21:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62874 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab0GCPVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 11:21:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kr0bAPJL8F7qcZNB7FWH0DDIaXxhlMwBC26INbWHIYs8A/udwTpb12M2dA67CTE+OF
         7Qkja8HDccwZ/Mov+zwLetSqIECRH7aWbGv1qCPFHkntMhLed7Z2NR6xMt8rtzlKZqZK
         wihOeGzaC0zVBQwiI05zKm/+/8Tw2K7hNDwJQ=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
       Roel Kluin <roel.kluin@gmail.com>, Arun Thomas <arun.thomas@gmail.com>,
       =?UTF-8?q?Jaakko=20Niemel=C3=A4?= <mato@kyborgi.net>,
       Vlatko Kosturjak <kost@linux.hr>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Bruce Jones <brucej@linux.com>, "BRAGA, Bruno" <bruno.braga@gmail.com>,
       Rich Folsom <rich.folsom@gmail.com>, Mark Rankilor <reodge@gmail.com>,
       Ian Abbott <abbotti@mev.co.uk>, Jason Wong <tsanghan@gmail.com>,
       Stoyan Gaydarov <sgayda2@uiuc.edu>,
       Andrea Gelmini <andrea.gelmini@gelma.net>,
       Dirk Hohndel <hohndel@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
       =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Gustavo Silva <silvagustavo@users.sourceforge.net>,
       matt mooney <mfm@muteddisk.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 01/19] staging/comedi: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 19:20:47 +0400
Message-Id: <1278170475-8204-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 .../comedi/drivers/addi-data/addi_amcc_s5933.h     |    6 ++----
 drivers/staging/comedi/drivers/adl_pci6208.c       |    6 ++----
 drivers/staging/comedi/drivers/adl_pci7230.c       |    7 ++-----
 drivers/staging/comedi/drivers/adl_pci7296.c       |    7 ++-----
 drivers/staging/comedi/drivers/adl_pci7432.c       |    7 ++-----
 drivers/staging/comedi/drivers/adl_pci8164.c       |    7 ++-----
 drivers/staging/comedi/drivers/adl_pci9111.c       |    6 ++----
 drivers/staging/comedi/drivers/adv_pci_dio.c       |    6 ++----
 drivers/staging/comedi/drivers/amplc_pci230.c      |    6 ++----
 drivers/staging/comedi/drivers/cb_pcidas.c         |    6 ++----
 drivers/staging/comedi/drivers/cb_pcidas64.c       |    6 ++----
 drivers/staging/comedi/drivers/cb_pcidda.c         |    6 ++----
 drivers/staging/comedi/drivers/cb_pcidio.c         |    4 +---
 drivers/staging/comedi/drivers/cb_pcimdas.c        |    6 ++----
 drivers/staging/comedi/drivers/cb_pcimdda.c        |    6 ++----
 drivers/staging/comedi/drivers/contec_pci_dio.c    |    7 ++-----
 drivers/staging/comedi/drivers/das08.c             |    6 ++----
 drivers/staging/comedi/drivers/icp_multi.h         |    6 ++----
 drivers/staging/comedi/drivers/ke_counter.c        |    6 ++----
 drivers/staging/comedi/drivers/me4000.c            |    6 ++----
 drivers/staging/comedi/drivers/me_daq.c            |    6 ++----
 drivers/staging/comedi/drivers/mite.c              |    6 ++----
 22 files changed, 43 insertions(+), 92 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h b/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
index c3284eb..8ed19bc 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
@@ -247,16 +247,14 @@ int i_pci_card_data(struct pcilst_struct *amcc,
 /* build list of amcc cards in this system */
 void v_pci_card_list_init(unsigned short pci_vendor, char display)
 {
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 	struct pcilst_struct *amcc, *last;
 	int i;
 	int i_Count = 0;
 	amcc_devices = NULL;
 	last = NULL;
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
+	for_each_pci_dev(pcidev) {
 		for (i_Count = 0; i_Count < 2; i_Count++) {
 			pci_vendor = i_ADDIDATADeviceID[i_Count];
 			if (pcidev->vendor == pci_vendor) {
diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 0bc6ac2..073d024 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -351,12 +351,10 @@ static int pci6208_ao_rinsn(struct comedi_device *dev,
 
 static int pci6208_find_device(struct comedi_device *dev, int bus, int slot)
 {
-	struct pci_dev *pci_dev;
+	struct pci_dev *pci_dev = NULL;
 	int i;
 
-	for (pci_dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pci_dev != NULL;
-	     pci_dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pci_dev)) {
+	for_each_pci_dev(pci_dev) {
 		if (pci_dev->vendor == PCI_VENDOR_ID_ADLINK) {
 			for (i = 0; i < ARRAY_SIZE(pci6208_boards); i++) {
 				if (pci6208_boards[i].dev_id ==
diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index caeb4e1..72a7258 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -90,7 +90,7 @@ static int adl_pci7230_do_insn_bits(struct comedi_device *dev,
 static int adl_pci7230_attach(struct comedi_device *dev,
 	struct comedi_devconfig *it)
 {
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 	struct comedi_subdevice *s;
 	int bus, slot;
 
@@ -106,10 +106,7 @@ static int adl_pci7230_attach(struct comedi_device *dev,
 	if (alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-		pcidev != NULL;
-		pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
-
+	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_ADLINK &&
 			pcidev->device == PCI_DEVICE_ID_PCI7230) {
 			if (bus || slot) {
diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index 947fae5..f28fe6b 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -77,7 +77,7 @@ static struct comedi_driver driver_adl_pci7296 = {
 static int adl_pci7296_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 	struct comedi_subdevice *s;
 	int bus, slot;
 	int ret;
@@ -94,10 +94,7 @@ static int adl_pci7296_attach(struct comedi_device *dev,
 	if (alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
-
+	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_ADLINK &&
 		    pcidev->device == PCI_DEVICE_ID_PCI7296) {
 			if (bus || slot) {
diff --git a/drivers/staging/comedi/drivers/adl_pci7432.c b/drivers/staging/comedi/drivers/adl_pci7432.c
index 3b2f8e3..262da7b 100644
--- a/drivers/staging/comedi/drivers/adl_pci7432.c
+++ b/drivers/staging/comedi/drivers/adl_pci7432.c
@@ -86,7 +86,7 @@ static int adl_pci7432_do_insn_bits(struct comedi_device *dev,
 static int adl_pci7432_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 	struct comedi_subdevice *s;
 	int bus, slot;
 
@@ -102,10 +102,7 @@ static int adl_pci7432_attach(struct comedi_device *dev,
 	if (alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
-
+	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_ADLINK &&
 		    pcidev->device == PCI_DEVICE_ID_PCI7432) {
 			if (bus || slot) {
diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 1b7155e..767a594 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -125,7 +125,7 @@ static int adl_pci8164_insn_write_buf1(struct comedi_device *dev,
 static int adl_pci8164_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 	struct comedi_subdevice *s;
 	int bus, slot;
 
@@ -142,10 +142,7 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 	if (alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
-
+	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_ADLINK &&
 		    pcidev->device == PCI_DEVICE_ID_PCI8164) {
 			if (bus || slot) {
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 1c5cb0e..896fec6 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -1265,7 +1265,7 @@ static int pci9111_attach(struct comedi_device *dev,
 {
 	struct comedi_subdevice *subdevice;
 	unsigned long io_base, io_range, lcr_io_base, lcr_io_range;
-	struct pci_dev *pci_device;
+	struct pci_dev *pci_device = NULL;
 	int error, i;
 	const struct pci9111_board *board;
 
@@ -1275,9 +1275,7 @@ static int pci9111_attach(struct comedi_device *dev,
 
 	printk("comedi%d: " PCI9111_DRIVER_NAME " driver\n", dev->minor);
 
-	for (pci_device = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pci_device != NULL;
-	     pci_device = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pci_device)) {
+	for_each_pci_dev(pci_device) {
 		if (pci_device->vendor == PCI_VENDOR_ID_ADLINK) {
 			for (i = 0; i < pci9111_board_nbr; i++) {
 				if (pci9111_boards[i].device_id ==
diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 31a6388..d018bb4 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1104,7 +1104,7 @@ static int pci_dio_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	int ret, subdev, n_subdevices, i, j;
 	unsigned long iobase;
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 
 	printk("comedi%d: adv_pci_dio: ", dev->minor);
 
@@ -1114,9 +1114,7 @@ static int pci_dio_attach(struct comedi_device *dev,
 		return -ENOMEM;
 	}
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
+	for_each_pci_dev(pcidev) {
 		/*  loop through cards supported by this driver */
 		for (i = 0; i < n_boardtypes; ++i) {
 			if (boardtypes[i].vendor_id != pcidev->vendor)
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index b572df7..5d06457 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -764,7 +764,7 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	unsigned long iobase1, iobase2;
 	/* PCI230's I/O spaces 1 and 2 respectively. */
-	struct pci_dev *pci_dev;
+	struct pci_dev *pci_dev = NULL;
 	int i = 0, irq_hdl, rc;
 
 	printk("comedi%d: amplc_pci230: attach %s %d,%d\n", dev->minor,
@@ -780,9 +780,7 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	spin_lock_init(&devpriv->ai_stop_spinlock);
 	spin_lock_init(&devpriv->ao_stop_spinlock);
 	/* Find card */
-	for (pci_dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pci_dev != NULL;
-	     pci_dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pci_dev)) {
+	for_each_pci_dev(pci_dev) {
 		if (it->options[0] || it->options[1]) {
 			/* Match against bus/slot options. */
 			if (it->options[0] != pci_dev->bus->number ||
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 2d9ad53..6530b6c 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -533,7 +533,7 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 			    struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 	int index;
 	int i;
 
@@ -550,9 +550,7 @@ static int cb_pcidas_attach(struct comedi_device *dev,
  */
 	printk("\n");
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
+	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
 		if (pcidev->vendor != PCI_VENDOR_ID_CB)
 			continue;
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index ba7c48a..53e7015 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1754,7 +1754,7 @@ static inline void warn_external_queue(struct comedi_device *dev)
  */
 static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 	int index;
 	uint32_t local_range, local_decode;
 	int retval;
@@ -1771,9 +1771,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * Probe the device to determine what device in the series it is.
  */
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
+	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
 		if (pcidev->vendor != PCI_VENDOR_ID_COMPUTERBOARDS)
 			continue;
diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 97d0015..2d35143 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -280,7 +280,7 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 			    struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 	int index;
 
 	printk("comedi%d: cb_pcidda: ", dev->minor);
@@ -296,9 +296,7 @@ static int cb_pcidda_attach(struct comedi_device *dev,
  */
 	printk("\n");
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
+	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_CB) {
 			if (it->options[0] || it->options[1]) {
 				if (pcidev->bus->number != it->options[0] ||
diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index a9d902f..c1693c9 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -202,9 +202,7 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * Probe the device to determine what device in the series it is.
  */
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
+	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
 		if (pcidev->vendor != PCI_VENDOR_ID_CB)
 			continue;
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index e50b8c2..ced346a 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -210,7 +210,7 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 			     struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 	int index;
 	/* int i; */
 
@@ -227,9 +227,7 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
  */
 	printk("\n");
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
+	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
 		if (pcidev->vendor != PCI_VENDOR_ID_COMPUTERBOARDS)
 			continue;
diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 3160330..8c981a8 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -464,13 +464,11 @@ static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
  */
 static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 {
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 	int index;
 	unsigned long registers;
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
+	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
 		if (pcidev->vendor != PCI_VENDOR_ID_COMPUTERBOARDS)
 			continue;
diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 24ac10c..871f109 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -103,7 +103,7 @@ static int contec_ns_to_timer(unsigned int *ns, int round);
 
 static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 	struct comedi_subdevice *s;
 
 	printk("comedi%d: contec: ", dev->minor);
@@ -116,10 +116,7 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
-
+	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_CONTEC &&
 		    pcidev->device == PCI_DEVICE_ID_PIO1616L) {
 			if (it->options[0] || it->options[1]) {
diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index ad18572..3141dc8 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -980,7 +980,7 @@ static int das08_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned long iobase;
 #ifdef CONFIG_COMEDI_PCI
 	unsigned long pci_iobase = 0;
-	struct pci_dev *pdev;
+	struct pci_dev *pdev = NULL;
 #endif
 
 	ret = alloc_private(dev, sizeof(struct das08_private_struct));
@@ -997,9 +997,7 @@ static int das08_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 		printk("\n");
 		/*  find card */
-		for (pdev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-		     pdev != NULL;
-		     pdev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pdev)) {
+		for_each_pci_dev(pdev) {
 			if (pdev->vendor == PCI_VENDOR_ID_COMPUTERBOARDS
 			    && pdev->device == PCI_DEVICE_ID_PCIDAS08) {
 				if (it->options[0] || it->options[1]) {
diff --git a/drivers/staging/comedi/drivers/icp_multi.h b/drivers/staging/comedi/drivers/icp_multi.h
index 2bb96b1..68acefe 100644
--- a/drivers/staging/comedi/drivers/icp_multi.h
+++ b/drivers/staging/comedi/drivers/icp_multi.h
@@ -62,16 +62,14 @@ static int pci_card_data(struct pcilst_struct *amcc,
 /* build list of Inova cards in this system */
 static void pci_card_list_init(unsigned short pci_vendor, char display)
 {
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 	struct pcilst_struct *inova, *last;
 	int i;
 
 	inova_devices = NULL;
 	last = NULL;
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
+	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == pci_vendor) {
 			inova = kzalloc(sizeof(*inova), GFP_KERNEL);
 			if (!inova) {
diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index e30aa01..286093b 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -188,7 +188,7 @@ static int cnt_rinsn(struct comedi_device *dev,
 static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *subdevice;
-	struct pci_dev *pci_device;
+	struct pci_dev *pci_device = NULL;
 	struct cnt_board_struct *board;
 	unsigned long io_base;
 	int error, i;
@@ -199,9 +199,7 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return error;
 
 	/* Probe the device to determine what device in the series it is. */
-	for (pci_device = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pci_device != NULL;
-	     pci_device = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pci_device)) {
+	for_each_pci_dev(pci_device) {
 		if (pci_device->vendor == PCI_VENDOR_ID_KOLTER) {
 			for (i = 0; i < cnt_board_nbr; i++) {
 				if (cnt_boards[i].device_id ==
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 56c9279..1471384 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -389,7 +389,7 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int me4000_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	struct pci_dev *pci_device;
+	struct pci_dev *pci_device = NULL;
 	int result, i;
 	struct me4000_board *board;
 
@@ -402,9 +402,7 @@ static int me4000_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 	/*
 	 * Probe the device to determine what device in the series it is.
 	 */
-	for (pci_device = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pci_device != NULL;
-	     pci_device = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pci_device)) {
+	for_each_pci_dev(pci_device) {
 		if (pci_device->vendor == PCI_VENDOR_ID_MEILHAUS) {
 			for (i = 0; i < ME4000_BOARD_VERSIONS; i++) {
 				if (me4000_boards[i].device_id ==
diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index 579e6a5..cda4b22 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -680,7 +680,7 @@ static int me_reset(struct comedi_device *dev)
  */
 static int me_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	struct pci_dev *pci_device;
+	struct pci_dev *pci_device = NULL;
 	struct comedi_subdevice *subdevice;
 	struct me_board *board;
 	resource_size_t plx_regbase_tmp;
@@ -697,9 +697,7 @@ static int me_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -ENOMEM;
 
 	/* Probe the device to determine what device in the series it is. */
-	for (pci_device = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pci_device != NULL;
-	     pci_device = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pci_device)) {
+	for_each_pci_dev(pci_device) {
 		if (pci_device->vendor == PCI_VENDOR_ID_MEILHAUS) {
 			for (i = 0; i < me_board_nbr; i++) {
 				if (me_boards[i].device_id ==
diff --git a/drivers/staging/comedi/drivers/mite.c b/drivers/staging/comedi/drivers/mite.c
index 4b7d207..cd25b24 100644
--- a/drivers/staging/comedi/drivers/mite.c
+++ b/drivers/staging/comedi/drivers/mite.c
@@ -70,12 +70,10 @@ EXPORT_SYMBOL(mite_devices);
 
 void mite_init(void)
 {
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev = NULL;
 	struct mite_struct *mite;
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
+	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_NI) {
 			unsigned i;
 
-- 
1.7.0.4

