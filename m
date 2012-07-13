Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169Ab2GMArj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 20:47:39 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:52004 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab2GMArd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 20:47:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1342140450!8472833!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] staging: comedi: remove the devpriv and thisboard macros
Date: Thu, 12 Jul 2012 17:47:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207121747.21955.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macros 'devpriv' and 'thisboard' rely on a local variable having
a specific name and yeild pointers derived from that variable. Replace
the macros with local variables where used and use to comedi_board()
helper to get the 'thisboard' pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../staging/comedi/drivers/addi-data/addi_common.c | 19 ++++--
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |  2 +
 .../comedi/drivers/addi-data/hwdrv_apci035.c       | 14 +++++
 .../comedi/drivers/addi-data/hwdrv_apci1032.c      | 11 +++-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 21 ++++++-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      | 17 +++++-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 16 ++++++
 .../comedi/drivers/addi-data/hwdrv_apci16xx.c      |  8 +++
 .../comedi/drivers/addi-data/hwdrv_apci2016.c      | 12 ++++
 .../comedi/drivers/addi-data/hwdrv_apci2032.c      | 14 +++++
 .../comedi/drivers/addi-data/hwdrv_apci2200.c      | 19 +++++-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      | 42 +++++++++++---
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      | 27 ++++++++-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      | 18 ++++++
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.c      | 18 ++++++
 drivers/staging/comedi/drivers/adl_pci9111.c       | 36 ++++++++----
 drivers/staging/comedi/drivers/adl_pci9118.c       | 55 ++++++++++++++++--
 drivers/staging/comedi/drivers/adq12b.c            | 10 +++-
 drivers/staging/comedi/drivers/adv_pci1710.c       | 45 +++++++++++++--
 drivers/staging/comedi/drivers/adv_pci1723.c       | 20 ++++---
 drivers/staging/comedi/drivers/adv_pci_dio.c       | 22 +++++--
 drivers/staging/comedi/drivers/aio_aio12_8.c       |  8 ++-
 drivers/staging/comedi/drivers/aio_iiro_16.c       | 11 ----
 drivers/staging/comedi/drivers/amplc_dio200.c      | 10 +++-
 drivers/staging/comedi/drivers/amplc_pc236.c       | 12 +++-
 drivers/staging/comedi/drivers/amplc_pc263.c       | 11 +++-
 drivers/staging/comedi/drivers/amplc_pci224.c      |  9 ++-
 drivers/staging/comedi/drivers/amplc_pci230.c      |  3 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |  4 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |  2 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         | 27 ++++-----
 drivers/staging/comedi/drivers/cb_pcidio.c         | 11 ++--
 drivers/staging/comedi/drivers/cb_pcimdas.c        | 23 ++++----
 drivers/staging/comedi/drivers/cb_pcimdda.c        | 29 +++++-----
 drivers/staging/comedi/drivers/comedi_bond.c       | 26 +++------
 drivers/staging/comedi/drivers/comedi_parport.c    | 16 +++++-
 drivers/staging/comedi/drivers/comedi_test.c       | 17 +++++-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |  6 +-
 drivers/staging/comedi/drivers/daqboard2000.c      | 27 +++++++--
 drivers/staging/comedi/drivers/das08.c             |  8 ++-
 drivers/staging/comedi/drivers/das08_cs.c          |  4 +-
 drivers/staging/comedi/drivers/das16.c             | 19 +++++-
 drivers/staging/comedi/drivers/das16m1.c           | 14 ++++-
 drivers/staging/comedi/drivers/das1800.c           | 41 +++++++++----
 drivers/staging/comedi/drivers/das6402.c           | 11 +++-
 drivers/staging/comedi/drivers/das800.c            | 29 +++++++---
 drivers/staging/comedi/drivers/dt2801.c            | 28 +++++----
 drivers/staging/comedi/drivers/dt2811.c            |  9 ++-
 drivers/staging/comedi/drivers/dt2814.c            |  8 ++-
 drivers/staging/comedi/drivers/dt2815.c            |  8 ++-
 drivers/staging/comedi/drivers/dt282x.c            | 67 +++++++++++++++-------
 drivers/staging/comedi/drivers/dt3000.c            | 28 +++++++--
 drivers/staging/comedi/drivers/dt9812.c            | 13 +++--
 drivers/staging/comedi/drivers/dyna_pci10xx.c      | 18 ++++--
 drivers/staging/comedi/drivers/fl512.c             |  9 ++-
 drivers/staging/comedi/drivers/icp_multi.c         | 36 +++++++++---
 drivers/staging/comedi/drivers/ii_pci20kc.c        | 10 +++-
 drivers/staging/comedi/drivers/jr3_pci.c           |  5 +-
 drivers/staging/comedi/drivers/me4000.c            | 55 ++++++++++++++----
 drivers/staging/comedi/drivers/me4000.h            |  4 --
 drivers/staging/comedi/drivers/me_daq.c            | 27 ++++++---
 drivers/staging/comedi/drivers/mpc624.c            |  6 +-
 drivers/staging/comedi/drivers/mpc8260cpm.c        | 11 ----
 drivers/staging/comedi/drivers/multiq3.c           |  7 ++-
 drivers/staging/comedi/drivers/ni_6527.c           | 23 ++++++--
 drivers/staging/comedi/drivers/ni_at_a2150.c       | 27 ++++++---
 drivers/staging/comedi/drivers/ni_at_ao.c          | 12 +++-
 drivers/staging/comedi/drivers/ni_atmio16d.c       | 11 +++-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      | 19 +-----
 drivers/staging/comedi/drivers/ni_labpc.c          | 53 ++++++++++++++---
 drivers/staging/comedi/drivers/ni_labpc_cs.c       | 10 ++--
 drivers/staging/comedi/drivers/ni_pcidio.c         | 34 ++++++++++-
 drivers/staging/comedi/drivers/ni_pcimio.c         |  4 +-
 drivers/staging/comedi/drivers/pcl711.c            | 11 +++-
 drivers/staging/comedi/drivers/pcl726.c            |  8 ++-
 drivers/staging/comedi/drivers/pcl812.c            | 23 ++++++--
 drivers/staging/comedi/drivers/pcl816.c            | 19 ++++--
 drivers/staging/comedi/drivers/pcl818.c            | 28 +++++++--
 drivers/staging/comedi/drivers/pcm3724.c           | 11 ++--
 drivers/staging/comedi/drivers/pcmad.c             |  6 +-
 drivers/staging/comedi/drivers/pcmda12.c           |  8 ++-
 drivers/staging/comedi/drivers/pcmmio.c            | 50 +++++++++++-----
 drivers/staging/comedi/drivers/pcmuio.c            | 30 ++++++----
 drivers/staging/comedi/drivers/rtd520.c            |  2 +-
 drivers/staging/comedi/drivers/rti800.c            |  9 ++-
 drivers/staging/comedi/drivers/rti802.c            |  8 ++-
 drivers/staging/comedi/drivers/s526.c              | 16 +++---
 drivers/staging/comedi/drivers/s626.c              |  5 +-
 drivers/staging/comedi/drivers/serial2002.c        | 21 ++++---
 89 files changed, 1204 insertions(+), 417 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index a5aa673..1e62f33 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -76,9 +76,6 @@ You should also find the complete GPL in the COPYING file accompanying this sour
 /* Update-0.7.57->0.7.68MODULE_DESCRIPTION("Comedi ADDI-DATA module"); */
 /* Update-0.7.57->0.7.68MODULE_LICENSE("GPL"); */
 
-#define devpriv ((struct addi_private *)dev->private)
-#define this_board ((const struct addi_board *)dev->board_ptr)
-
 #if defined(CONFIG_APCI_1710) || defined(CONFIG_APCI_3200) || defined(CONFIG_APCI_3300)
 /* BYTE b_SaveFPUReg [94]; */
 
@@ -1495,6 +1492,8 @@ module_exit(driver_addi_cleanup_module);
 
 static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret, pages, i, n_subdevices;
 	unsigned int dw_Dummy;
@@ -1505,9 +1504,10 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned char pci_bus, pci_slot, pci_func;
 	int i_Dma = 0;
 
-	ret = alloc_private(dev, sizeof(struct addi_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	if (!pci_list_builded) {
 		v_pci_card_list_init(this_board->i_VendorId, 1);	/* 1 for displaying the list.. */
@@ -1840,7 +1840,10 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void i_ADDI_Detach(struct comedi_device *dev)
 {
-	if (dev->private) {
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
+
+	if (devpriv) {
 		if (devpriv->b_ValidDriver)
 			i_ADDI_Reset(dev);
 		if (dev->irq)
@@ -1891,6 +1894,7 @@ static void i_ADDI_Detach(struct comedi_device *dev)
 
 static int i_ADDI_Reset(struct comedi_device *dev)
 {
+	const struct addi_board *this_board = comedi_board(dev);
 
 	this_board->reset(dev);
 	return 0;
@@ -1918,6 +1922,8 @@ static int i_ADDI_Reset(struct comedi_device *dev)
 static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	const struct addi_board *this_board = comedi_board(dev);
+
 	this_board->interrupt(irq, d);
 	return IRQ_RETVAL(1);
 }
@@ -1946,8 +1952,11 @@ static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
 static int i_ADDIDATA_InsnReadEeprom(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
 	unsigned short w_Data;
 	unsigned short w_Address;
+
 	w_Address = CR_CHAN(insn->chanspec);	/*  address to be read as 0,1,2,3...255 */
 
 	w_Data = w_EepromReadWord(devpriv->i_IobaseAmcc,
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c b/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
index 3a9339b..5d31ecd 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
@@ -805,6 +805,8 @@ void v_EepromCs76Read(unsigned int dw_Address, unsigned short w_offset, unsigned
 int i_EepromReadMainHeader(unsigned short w_PCIBoardEepromAddress,
 	char *pc_PCIChipInformation, struct comedi_device *dev)
 {
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
 	unsigned short w_Temp, i, w_Count = 0;
 	unsigned int ui_Temp;
 	struct str_MainHeader s_MainHeader;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 5997b2f..0fde7a3 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -112,9 +112,11 @@ static int i_Flag = 1;
 int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Status = 0;
 	unsigned int ui_Command = 0;
 	unsigned int ui_Mode = 0;
+
 	i_Temp = 0;
 	devpriv->tsk_Current = current;
 	devpriv->b_TimerSelectMode = data[0];
@@ -281,8 +283,10 @@ int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev, struct comedi_subde
 int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Command = 0;
 	int i_Count = 0;
+
 	if (data[0] == 1) {
 		ui_Command =
 			inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
@@ -396,7 +400,9 @@ int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
 int i_APCI035_ReadTimerWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Status = 0;	/*  Status register */
+
 	i_WatchdogNbr = insn->unused[0];
 
 	/******************/
@@ -456,6 +462,8 @@ int i_APCI035_ReadTimerWatchdog(struct comedi_device *dev, struct comedi_subdevi
 int i_APCI035_ConfigAnalogInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	devpriv->tsk_Current = current;
 	outl(0x200 | 0, devpriv->iobase + 128 + 0x4);
 	outl(0, devpriv->iobase + 128 + 0);
@@ -493,7 +501,9 @@ int i_APCI035_ConfigAnalogInput(struct comedi_device *dev, struct comedi_subdevi
 int i_APCI035_ReadAnalogInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_CommandRegister = 0;
+
 /******************/
 /*  Set the start */
 /******************/
@@ -527,7 +537,9 @@ int i_APCI035_ReadAnalogInput(struct comedi_device *dev, struct comedi_subdevice
 */
 int i_APCI035_Reset(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_Count = 0;
+
 	for (i_Count = 1; i_Count <= 4; i_Count++) {
 		i_WatchdogNbr = i_Count;
 		outl(0x0, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 0);	/* stop all timers */
@@ -557,11 +569,13 @@ int i_APCI035_Reset(struct comedi_device *dev)
 static void v_APCI035_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_StatusRegister1 = 0;
 	unsigned int ui_StatusRegister2 = 0;
 	unsigned int ui_ReadCommand = 0;
 	unsigned int ui_ChannelNumber = 0;
 	unsigned int ui_DigitalTemperature = 0;
+
 	if (i_Temp == 1) {
 		i_WatchdogNbr = i_Flag;
 		i_Flag = i_Flag + 1;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
index bab7b61..285c5c0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
@@ -87,10 +87,11 @@ static unsigned int ui_InterruptStatus;
 int i_APCI1032_ConfigDigitalInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_TmpValue;
-
 	unsigned int ul_Command1 = 0;
 	unsigned int ul_Command2 = 0;
+
 	devpriv->tsk_Current = current;
 
   /*******************************/
@@ -147,8 +148,10 @@ int i_APCI1032_ConfigDigitalInput(struct comedi_device *dev, struct comedi_subde
 int i_APCI1032_Read1DigitalInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_TmpValue = 0;
 	unsigned int ui_Channel;
+
 	ui_Channel = CR_CHAN(insn->chanspec);
 	if (ui_Channel <= 31) {
 		ui_TmpValue = (unsigned int) inl(devpriv->iobase + APCI1032_DIGITAL_IP);
@@ -188,6 +191,7 @@ int i_APCI1032_Read1DigitalInput(struct comedi_device *dev, struct comedi_subdev
 int i_APCI1032_ReadMoreDigitalInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_PortValue = data[0];
 	unsigned int ui_Mask = 0;
 	unsigned int ui_NoOfChannels;
@@ -248,8 +252,9 @@ int i_APCI1032_ReadMoreDigitalInput(struct comedi_device *dev, struct comedi_sub
 static void v_APCI1032_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp;
+
 	/* disable the interrupt */
 	ui_Temp = inl(devpriv->iobase + APCI1032_DIGITAL_IP_IRQ);
 	outl(ui_Temp & APCI1032_DIGITAL_IP_INTERRUPT_DISABLE,
@@ -279,6 +284,8 @@ static void v_APCI1032_Interrupt(int irq, void *d)
 
 int i_APCI1032_Reset(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
+
 	outl(0x0, devpriv->iobase + APCI1032_DIGITAL_IP_IRQ);	/* disable the interrupts */
 	inl(devpriv->iobase + APCI1032_DIGITAL_IP_INTERRUPT_STATUS);	/* Reset the interrupt status register */
 	outl(0x0, devpriv->iobase + APCI1032_DIGITAL_IP_INTERRUPT_MODE1);	/* Disable the and/or interrupt */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 62f421a..3ad728e 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -141,6 +141,7 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 					      struct comedi_insn *insn,
 					      unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_PatternPolarity = 0, i_PatternTransition = 0, i_PatternMask = 0;
 	int i_MaxChannel = 0, i_Count = 0, i_EventMask = 0;
 	int i_PatternTransitionCount = 0, i_RegValue;
@@ -525,8 +526,10 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 					  struct comedi_insn *insn,
 					  unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_Event1InterruptStatus = 0, i_Event2InterruptStatus =
 		0, i_RegValue;
+
 	switch (data[0]) {
 	case START:
 	      /*************************/
@@ -792,7 +795,9 @@ static int i_APCI1500_Initialisation(struct comedi_device *dev,
 				     struct comedi_insn *insn,
 				     unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_DummyRead = 0;
+
     /******************/
 	/* Software reset */
     /******************/
@@ -966,10 +971,12 @@ static int i_APCI1500_ReadMoreDigitalInput(struct comedi_device *dev,
 					   struct comedi_insn *insn,
 					   unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_PortValue = data[1];
 	unsigned int ui_Mask = 0;
 	unsigned int ui_Channel;
 	unsigned int ui_TmpValue = 0;
+
 	ui_Channel = CR_CHAN(insn->chanspec);
 
 	switch (data[0]) {
@@ -1051,6 +1058,8 @@ static int i_APCI1500_ConfigDigitalOutputErrorInterrupt(struct comedi_device *de
 							struct comedi_insn *insn,
 							unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	devpriv->b_OutputMemoryStatus = data[0];
 	return insn->n;
 }
@@ -1079,9 +1088,9 @@ static int i_APCI1500_WriteDigitalOutput(struct comedi_device *dev,
 					 struct comedi_insn *insn,
 					 unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	static unsigned int ui_Temp = 0;
 	unsigned int ui_Temp1;
-
 	unsigned int ui_NoOfChannel = CR_CHAN(insn->chanspec);	/*  get the channel */
 
 	if (!devpriv->b_OutputMemoryStatus) {
@@ -1274,6 +1283,7 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 						 struct comedi_insn *insn,
 						 unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_TimerCounterMode, i_MasterConfiguration;
 
 	devpriv->tsk_Current = current;
@@ -1875,6 +1885,7 @@ static int i_APCI1500_StartStopTriggerTimerCounterWatchdog(struct comedi_device
 							   struct comedi_insn *insn,
 							   unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_CommandAndStatusValue;
 
 	switch (data[0]) {
@@ -2198,7 +2209,9 @@ static int i_APCI1500_ReadCounterTimerWatchdog(struct comedi_device *dev,
 					       struct comedi_insn *insn,
 					       unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_CommandAndStatusValue;
+
 	switch (data[0]) {
 	case COUNTER1:
 		/* Read counter/timer1 */
@@ -2421,9 +2434,11 @@ static int i_APCI1500_ConfigureInterrupt(struct comedi_device *dev,
 					 struct comedi_insn *insn,
 					 unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Status;
 	int i_RegValue;
 	int i_Constant;
+
 	devpriv->tsk_Current = current;
 	outl(0x0, devpriv->i_IobaseAmcc + 0x38);
 	if (data[0] == 1) {
@@ -2597,8 +2612,10 @@ static void v_APCI1500_Interrupt(int irq, void *d)
 {
 
 	struct comedi_device *dev = d;
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_InterruptStatus = 0;
 	int i_RegValue = 0;
+
 	i_InterruptMask = 0;
 
  /***********************************/
@@ -2840,7 +2857,9 @@ static void v_APCI1500_Interrupt(int irq, void *d)
 */
 static int i_APCI1500_Reset(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_DummyRead = 0;
+
 	i_TimerCounter1Init = 0;
 	i_TimerCounter2Init = 0;
 	i_WatchdogCounter3Init = 0;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
index 8a584a0..04a8745 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
@@ -76,8 +76,10 @@ You should also find the complete GPL in the COPYING file accompanying this sour
 int i_APCI1516_Read1DigitalInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_TmpValue = 0;
 	unsigned int ui_Channel;
+
 	ui_Channel = CR_CHAN(insn->chanspec);
 	if (ui_Channel <= 7) {
 		ui_TmpValue = (unsigned int) inw(devpriv->iobase + APCI1516_DIGITAL_IP);
@@ -117,7 +119,7 @@ int i_APCI1516_Read1DigitalInput(struct comedi_device *dev, struct comedi_subdev
 int i_APCI1516_ReadMoreDigitalInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
-
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_PortValue = data[0];
 	unsigned int ui_Mask = 0;
 	unsigned int ui_NoOfChannels;
@@ -174,6 +176,8 @@ int i_APCI1516_ReadMoreDigitalInput(struct comedi_device *dev, struct comedi_sub
 int i_APCI1516_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	devpriv->b_OutputMemoryStatus = data[0];
 	return insn->n;
 }
@@ -202,6 +206,7 @@ int i_APCI1516_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subd
 int i_APCI1516_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp, ui_Temp1;
 	unsigned int ui_NoOfChannel = CR_CHAN(insn->chanspec);	/*  get the channel */
 
@@ -363,8 +368,10 @@ int i_APCI1516_ReadDigitalOutput(struct comedi_device *dev, struct comedi_subdev
 	struct comedi_insn *insn, unsigned int *data)
 {
 
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp;
 	unsigned int ui_NoOfChannel = CR_CHAN(insn->chanspec);	/*  get the channel */
+
 	ui_Temp = data[0];
 	*data = inw(devpriv->iobase + APCI1516_DIGITAL_OP_RW);
 	if (ui_Temp == 0) {
@@ -422,6 +429,8 @@ int i_APCI1516_ReadDigitalOutput(struct comedi_device *dev, struct comedi_subdev
 int i_APCI1516_ConfigWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	if (data[0] == 0) {
 		/* Disable the watchdog */
 		outw(0x0,
@@ -468,6 +477,8 @@ int i_APCI1516_ConfigWatchdog(struct comedi_device *dev, struct comedi_subdevice
 int i_APCI1516_StartStopWriteWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	switch (data[0]) {
 	case 0:		/* stop the watchdog */
 		outw(0x0, devpriv->i_IobaseAddon + APCI1516_WATCHDOG_ENABLEDISABLE);	/* disable the watchdog */
@@ -513,6 +524,8 @@ int i_APCI1516_StartStopWriteWatchdog(struct comedi_device *dev, struct comedi_s
 int i_APCI1516_ReadWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	data[0] = inw(devpriv->i_IobaseAddon + APCI1516_WATCHDOG_STATUS) & 0x1;
 	return insn->n;
 }
@@ -534,6 +547,8 @@ int i_APCI1516_ReadWatchdog(struct comedi_device *dev, struct comedi_subdevice *
 
 int i_APCI1516_Reset(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
+
 	outw(0x0, devpriv->iobase + APCI1516_DIGITAL_OP);	/* RESETS THE DIGITAL OUTPUTS */
 	outw(0x0, devpriv->i_IobaseAddon + APCI1516_WATCHDOG_ENABLEDISABLE);
 	outw(0x0, devpriv->i_IobaseAddon + APCI1516_WATCHDOG_RELOAD_VALUE);
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 5b92e45..393d6d1 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -89,6 +89,8 @@ static unsigned int ui_InterruptData, ui_Type;
 int i_APCI1564_ConfigDigitalInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	devpriv->tsk_Current = current;
    /*******************************/
 	/* Set the digital input logic */
@@ -150,6 +152,7 @@ int i_APCI1564_ConfigDigitalInput(struct comedi_device *dev, struct comedi_subde
 int i_APCI1564_Read1DigitalInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_TmpValue = 0;
 	unsigned int ui_Channel;
 
@@ -192,6 +195,7 @@ int i_APCI1564_Read1DigitalInput(struct comedi_device *dev, struct comedi_subdev
 int i_APCI1564_ReadMoreDigitalInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_PortValue = data[0];
 	unsigned int ui_Mask = 0;
 	unsigned int ui_NoOfChannels;
@@ -260,6 +264,7 @@ int i_APCI1564_ReadMoreDigitalInput(struct comedi_device *dev, struct comedi_sub
 int i_APCI1564_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command = 0;
 
 	if ((data[0] != 0) && (data[0] != 1)) {
@@ -317,6 +322,7 @@ int i_APCI1564_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subd
 int i_APCI1564_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp, ui_Temp1;
 	unsigned int ui_NoOfChannel;
 
@@ -491,6 +497,7 @@ int i_APCI1564_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subde
 int i_APCI1564_ReadDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp;
 	unsigned int ui_NoOfChannel;
 
@@ -569,7 +576,9 @@ int i_APCI1564_ReadDigitalOutput(struct comedi_device *dev, struct comedi_subdev
 int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
+
 	devpriv->tsk_Current = current;
 	if (data[0] == ADDIDATA_WATCHDOG) {
 		devpriv->b_TimerSelectMode = ADDIDATA_WATCHDOG;
@@ -723,7 +732,9 @@ int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
+
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 		switch (data[1]) {
 		case 0:	/* stop the watchdog */
@@ -818,6 +829,7 @@ int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *dev,
 int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
 
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
@@ -921,10 +933,12 @@ int i_APCI1564_ReadInterruptStatus(struct comedi_device *dev, struct comedi_subd
 static void v_APCI1564_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_DO, ui_DI;
 	unsigned int ui_Timer;
 	unsigned int ui_C1, ui_C2, ui_C3, ui_C4;
 	unsigned int ul_Command2 = 0;
+
 	ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
 		APCI1564_DIGITAL_IP_IRQ) & 0x01;
 	ui_DO = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
@@ -1106,6 +1120,8 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
 int i_APCI1564_Reset(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
+
 	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_IRQ);	/* disable the interrupts */
 	inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_STATUS);	/* Reset the interrupt status register */
 	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_MODE1);	/* Disable the and/or interrupt */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c
index 00a088f..3f55cd0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c
@@ -93,6 +93,8 @@ You should also find the complete GPL in the COPYING file accompanying this sour
 int i_APCI16XX_InsnConfigInitTTLIO(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
 	int i_ReturnValue = insn->n;
 	unsigned char b_Command = 0;
 	unsigned char b_Cpt = 0;
@@ -286,6 +288,8 @@ int i_APCI16XX_InsnConfigInitTTLIO(struct comedi_device *dev,
 int i_APCI16XX_InsnBitsReadTTLIO(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
 	int i_ReturnValue = insn->n;
 	unsigned char b_Command = 0;
 	unsigned char b_NumberOfPort =
@@ -433,6 +437,8 @@ int i_APCI16XX_InsnBitsReadTTLIO(struct comedi_device *dev,
 int i_APCI16XX_InsnReadTTLIOAllPortValue(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
 	unsigned char b_Command = (unsigned char) CR_AREF(insn->chanspec);
 	int i_ReturnValue = insn->n;
 	unsigned char b_Cpt = 0;
@@ -573,6 +579,8 @@ int i_APCI16XX_InsnReadTTLIOAllPortValue(struct comedi_device *dev,
 int i_APCI16XX_InsnBitsWriteTTLIO(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
 	int i_ReturnValue = insn->n;
 	unsigned char b_Command = 0;
 	unsigned char b_NumberOfPort =
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
index 49dcbe2..b8721dd1 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
@@ -78,6 +78,8 @@ You should also find the complete GPL in the COPYING file accompanying this sour
 int i_APCI2016_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	if ((data[0] != 0) && (data[0] != 1)) {
 		comedi_error(dev,
 			"Not a valid Data !!! ,Data should be 1 or 0\n");
@@ -114,8 +116,10 @@ int i_APCI2016_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subd
 int i_APCI2016_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_NoOfChannel;
 	unsigned int ui_Temp, ui_Temp1;
+
 	ui_NoOfChannel = CR_CHAN(insn->chanspec);
 	if (ui_NoOfChannel > 15) {
 		comedi_error(dev,
@@ -269,8 +273,10 @@ int i_APCI2016_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subde
 int i_APCI2016_BitsDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp;
 	unsigned int ui_NoOfChannel;
+
 	ui_NoOfChannel = CR_CHAN(insn->chanspec);
 	if (ui_NoOfChannel > 15) {
 		comedi_error(dev,
@@ -340,6 +346,7 @@ int i_APCI2016_BitsDigitalOutput(struct comedi_device *dev, struct comedi_subdev
 int i_APCI2016_ConfigWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 
 	if (data[0] == 0) {
 		/* Disable the watchdog */
@@ -383,6 +390,7 @@ int i_APCI2016_ConfigWatchdog(struct comedi_device *dev, struct comedi_subdevice
 int i_APCI2016_StartStopWriteWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 
 	switch (data[0]) {
 	case 0:		/* stop the watchdog */
@@ -430,6 +438,8 @@ int i_APCI2016_StartStopWriteWatchdog(struct comedi_device *dev, struct comedi_s
 int i_APCI2016_ReadWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	udelay(5);
 	data[0] = inw(devpriv->i_IobaseAddon + APCI2016_WATCHDOG_STATUS) & 0x1;
 	return insn->n;
@@ -452,6 +462,8 @@ int i_APCI2016_ReadWatchdog(struct comedi_device *dev, struct comedi_subdevice *
 
 int i_APCI2016_Reset(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
+
 	outw(0x0, devpriv->iobase + APCI2016_DIGITAL_OP);	/*  Resets the digital output channels */
 	outw(0x0, devpriv->i_IobaseAddon + APCI2016_WATCHDOG_ENABLEDISABLE);
 	outw(0x0, devpriv->i_IobaseAddon + APCI2016_WATCHDOG_RELOAD_VALUE);
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
index 002297d..ad57f02 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
@@ -82,7 +82,9 @@ static unsigned int ui_InterruptData, ui_Type;
 int i_APCI2032_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command = 0;
+
 	devpriv->tsk_Current = current;
 
 	if ((data[0] != 0) && (data[0] != 1)) {
@@ -137,8 +139,10 @@ int i_APCI2032_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subd
 int i_APCI2032_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp, ui_Temp1;
 	unsigned int ui_NoOfChannel = CR_CHAN(insn->chanspec);	/*  get the channel */
+
 	if (devpriv->b_OutputMemoryStatus) {
 		ui_Temp = inl(devpriv->iobase + APCI2032_DIGITAL_OP);
 
@@ -316,8 +320,10 @@ int i_APCI2032_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subde
 int i_APCI2032_ReadDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp;
 	unsigned int ui_NoOfChannel;
+
 	ui_NoOfChannel = CR_CHAN(insn->chanspec);
 	ui_Temp = data[0];
 	*data = inl(devpriv->iobase + APCI2032_DIGITAL_OP_RW);
@@ -383,6 +389,8 @@ int i_APCI2032_ReadDigitalOutput(struct comedi_device *dev, struct comedi_subdev
 int i_APCI2032_ConfigWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	if (data[0] == 0) {
 		/* Disable the watchdog */
 		outl(0x0,
@@ -424,6 +432,8 @@ int i_APCI2032_ConfigWatchdog(struct comedi_device *dev, struct comedi_subdevice
 int i_APCI2032_StartStopWriteWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	switch (data[0]) {
 	case 0:		/* stop the watchdog */
 		outl(0x0, devpriv->iobase + APCI2032_DIGITAL_OP_WATCHDOG + APCI2032_TCW_PROG);	/* disable the watchdog */
@@ -469,6 +479,7 @@ int i_APCI2032_StartStopWriteWatchdog(struct comedi_device *dev, struct comedi_s
 int i_APCI2032_ReadWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 
 	data[0] =
 		inl(devpriv->iobase + APCI2032_DIGITAL_OP_WATCHDOG +
@@ -496,6 +507,7 @@ int i_APCI2032_ReadWatchdog(struct comedi_device *dev, struct comedi_subdevice *
 void v_APCI2032_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_DO;
 
 	ui_DO = inl(devpriv->iobase + APCI2032_DIGITAL_OP_IRQ) & 0x1;	/* Check if VCC OR CC interrupt has occurred. */
@@ -569,6 +581,8 @@ int i_APCI2032_ReadInterruptStatus(struct comedi_device *dev, struct comedi_subd
 
 int i_APCI2032_Reset(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
+
 	devpriv->b_DigitalOutputRegister = 0;
 	ui_Type = 0;
 	outl(0x0, devpriv->iobase + APCI2032_DIGITAL_OP);	/* Resets the output channels */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
index 3d378b5..db74f77 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
@@ -76,8 +76,10 @@ You should also find the complete GPL in the COPYING file accompanying this sour
 int i_APCI2200_Read1DigitalInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_TmpValue = 0;
 	unsigned int ui_Channel;
+
 	ui_Channel = CR_CHAN(insn->chanspec);
 	if (ui_Channel <= 7) {
 		ui_TmpValue = (unsigned int) inw(devpriv->iobase + APCI2200_DIGITAL_IP);
@@ -115,7 +117,7 @@ int i_APCI2200_Read1DigitalInput(struct comedi_device *dev, struct comedi_subdev
 int i_APCI2200_ReadMoreDigitalInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
-
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_PortValue = data[0];
 	unsigned int ui_Mask = 0;
 	unsigned int ui_NoOfChannels;
@@ -172,6 +174,8 @@ int i_APCI2200_ReadMoreDigitalInput(struct comedi_device *dev, struct comedi_sub
 int i_APCI2200_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	devpriv->b_OutputMemoryStatus = data[0];
 	return insn->n;
 }
@@ -200,8 +204,10 @@ int i_APCI2200_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subd
 int i_APCI2200_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp, ui_Temp1;
 	unsigned int ui_NoOfChannel = CR_CHAN(insn->chanspec);	/*  get the channel */
+
 	if (devpriv->b_OutputMemoryStatus) {
 		ui_Temp = inw(devpriv->iobase + APCI2200_DIGITAL_OP);
 
@@ -357,9 +363,10 @@ int i_APCI2200_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subde
 int i_APCI2200_ReadDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
-
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp;
 	unsigned int ui_NoOfChannel = CR_CHAN(insn->chanspec);	/*  get the channel */
+
 	ui_Temp = data[0];
 	*data = inw(devpriv->iobase + APCI2200_DIGITAL_OP);
 	if (ui_Temp == 0) {
@@ -421,6 +428,8 @@ int i_APCI2200_ReadDigitalOutput(struct comedi_device *dev, struct comedi_subdev
 int i_APCI2200_ConfigWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	if (data[0] == 0) {
 		/* Disable the watchdog */
 		outw(0x0,
@@ -467,6 +476,8 @@ int i_APCI2200_ConfigWatchdog(struct comedi_device *dev, struct comedi_subdevice
 int i_APCI2200_StartStopWriteWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	switch (data[0]) {
 	case 0:		/* stop the watchdog */
 		outw(0x0, devpriv->iobase + APCI2200_WATCHDOG + APCI2200_WATCHDOG_ENABLEDISABLE);	/* disable the watchdog */
@@ -512,6 +523,8 @@ int i_APCI2200_StartStopWriteWatchdog(struct comedi_device *dev, struct comedi_s
 int i_APCI2200_ReadWatchdog(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	data[0] =
 		inw(devpriv->iobase + APCI2200_WATCHDOG +
 		APCI2200_WATCHDOG_STATUS) & 0x1;
@@ -535,6 +548,8 @@ int i_APCI2200_ReadWatchdog(struct comedi_device *dev, struct comedi_subdevice *
 
 int i_APCI2200_Reset(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
+
 	outw(0x0, devpriv->iobase + APCI2200_DIGITAL_OP);	/* RESETS THE DIGITAL OUTPUTS */
 	outw(0x0,
 		devpriv->iobase + APCI2200_WATCHDOG +
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index ffe390c..6073e50 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -77,6 +77,7 @@ static unsigned int ui_Temp;
 int i_APCI3120_InsnConfigAnalogInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int i;
 
 	if ((data[0] != APCI3120_EOC_MODE) && (data[0] != APCI3120_EOS_MODE))
@@ -146,6 +147,8 @@ int i_APCI3120_InsnConfigAnalogInput(struct comedi_device *dev, struct comedi_su
 int i_APCI3120_InsnReadAnalogInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
 	unsigned short us_ConvertTiming, us_TmpValue, i;
 	unsigned char b_Tmp;
 
@@ -407,6 +410,8 @@ int i_APCI3120_InsnReadAnalogInput(struct comedi_device *dev, struct comedi_subd
 
 int i_APCI3120_StopCyclicAcquisition(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct addi_private *devpriv = dev->private;
+
 	/*  Disable A2P Fifo write and AMWEN signal */
 	outw(0, devpriv->i_IobaseAddon + 4);
 
@@ -478,6 +483,8 @@ int i_APCI3120_StopCyclicAcquisition(struct comedi_device *dev, struct comedi_su
 int i_APCI3120_CommandTestAnalogInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_cmd *cmd)
 {
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
 	int err = 0;
 	int tmp;		/*  divisor1,divisor2; */
 
@@ -635,6 +642,7 @@ int i_APCI3120_CommandTestAnalogInput(struct comedi_device *dev, struct comedi_s
 
 int i_APCI3120_CommandAnalogInput(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct addi_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
 	/* loading private structure with cmd structure inputs */
@@ -709,6 +717,8 @@ int i_APCI3120_CommandAnalogInput(struct comedi_device *dev, struct comedi_subde
 int i_APCI3120_CyclicAnalogInput(int mode, struct comedi_device *dev,
 	struct comedi_subdevice *s)
 {
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
 	unsigned char b_Tmp;
 	unsigned int ui_Tmp, ui_DelayTiming = 0, ui_TimerValue1 = 0, dmalen0 =
 		0, dmalen1 = 0, ui_TimerValue2 =
@@ -1242,6 +1252,7 @@ int i_APCI3120_CyclicAnalogInput(int mode, struct comedi_device *dev,
 
 int i_APCI3120_Reset(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int i;
 	unsigned short us_TmpValue;
 
@@ -1323,6 +1334,7 @@ int i_APCI3120_Reset(struct comedi_device *dev)
 int i_APCI3120_SetupChannelList(struct comedi_device *dev, struct comedi_subdevice *s,
 	int n_chan, unsigned int *chanlist, char check)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int i;		/* , differencial=0, bipolar=0; */
 	unsigned int gain;
 	unsigned short us_TmpValue;
@@ -1385,6 +1397,7 @@ int i_APCI3120_SetupChannelList(struct comedi_device *dev, struct comedi_subdevi
 
 int i_APCI3120_ExttrigEnable(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
 
 	devpriv->us_OutputRegister |= APCI3120_ENABLE_EXT_TRIGGER;
 	outw(devpriv->us_OutputRegister, dev->iobase + APCI3120_WR_ADDRESS);
@@ -1410,6 +1423,8 @@ int i_APCI3120_ExttrigEnable(struct comedi_device *dev)
 
 int i_APCI3120_ExttrigDisable(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
+
 	devpriv->us_OutputRegister &= ~APCI3120_ENABLE_EXT_TRIGGER;
 	outw(devpriv->us_OutputRegister, dev->iobase + APCI3120_WR_ADDRESS);
 	return 0;
@@ -1445,13 +1460,13 @@ int i_APCI3120_ExttrigDisable(struct comedi_device *dev)
 void v_APCI3120_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct addi_private *devpriv = dev->private;
 	unsigned short int_daq;
-
 	unsigned int int_amcc, ui_Check, i;
 	unsigned short us_TmpValue;
 	unsigned char b_DummyRead;
-
 	struct comedi_subdevice *s = dev->subdevices + 0;
+
 	ui_Check = 1;
 
 	int_daq = inw(dev->iobase + APCI3120_RD_STATUS) & 0xf000;	/*  get IRQ reasons */
@@ -1655,6 +1670,7 @@ void v_APCI3120_Interrupt(int irq, void *d)
 
 int i_APCI3120_InterruptHandleEos(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
 	int n_chan, i;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	int err = 1;
@@ -1698,11 +1714,12 @@ int i_APCI3120_InterruptHandleEos(struct comedi_device *dev)
 void v_APCI3120_InterruptDma(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct addi_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	unsigned int next_dma_buf, samplesinbuf;
 	unsigned long low_word, high_word, var;
-
 	unsigned int ui_Tmp;
+
 	samplesinbuf =
 		devpriv->ui_DmaBufferUsesize[devpriv->ui_DmaActualBuffer] -
 		inl(devpriv->i_IobaseAmcc + AMCC_OP_REG_MWTC);
@@ -1868,6 +1885,8 @@ void v_APCI3120_InterruptDma(int irq, void *d)
 void v_APCI3120_InterruptDmaMoveBlock16bit(struct comedi_device *dev,
 	struct comedi_subdevice *s, short *dma_buffer, unsigned int num_samples)
 {
+	struct addi_private *devpriv = dev->private;
+
 	devpriv->ui_AiActualScan +=
 		(s->async->cur_chan + num_samples) / devpriv->ui_AiScanLength;
 	s->async->cur_chan += num_samples;
@@ -1910,7 +1929,8 @@ void v_APCI3120_InterruptDmaMoveBlock16bit(struct comedi_device *dev,
 int i_APCI3120_InsnConfigTimer(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
-
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Timervalue2;
 	unsigned short us_TmpValue;
 	unsigned char b_Tmp;
@@ -2068,7 +2088,8 @@ int i_APCI3120_InsnConfigTimer(struct comedi_device *dev, struct comedi_subdevic
 int i_APCI3120_InsnWriteTimer(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
-
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Timervalue2 = 0;
 	unsigned short us_TmpValue;
 	unsigned char b_Tmp;
@@ -2252,6 +2273,7 @@ int i_APCI3120_InsnWriteTimer(struct comedi_device *dev, struct comedi_subdevice
 int i_APCI3120_InsnReadTimer(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned char b_Tmp;
 	unsigned short us_TmpValue, us_TmpValue_2, us_StatusValue;
 
@@ -2327,6 +2349,7 @@ int i_APCI3120_InsnReadDigitalInput(struct comedi_device *dev,
 				    struct comedi_insn *insn,
 				    unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Chan, ui_TmpValue;
 
 	ui_Chan = CR_CHAN(insn->chanspec);	/*  channel specified */
@@ -2371,7 +2394,9 @@ int i_APCI3120_InsnReadDigitalInput(struct comedi_device *dev,
 int i_APCI3120_InsnBitsDigitalInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_TmpValue;
+
 	ui_TmpValue = (unsigned int) inw(devpriv->iobase + APCI3120_RD_STATUS);
 	/*****	state of 4 channels  in the 11, 10, 9, 8   bits of status reg
 			rotated right 8 times to bring them to last four bits
@@ -2410,6 +2435,7 @@ int i_APCI3120_InsnBitsDigitalInput(struct comedi_device *dev, struct comedi_sub
 int i_APCI3120_InsnConfigDigitalOutput(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 
 	if ((data[0] != 0) && (data[0] != 1)) {
 		comedi_error(dev,
@@ -2457,6 +2483,8 @@ int i_APCI3120_InsnBitsDigitalOutput(struct comedi_device *dev,
 				     struct comedi_insn *insn,
 				     unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	if ((data[0] > devpriv->s_EeParameters.i_DoMaxdata) || (data[0] < 0)) {
 
 		comedi_error(dev, "Data is not valid !!! \n");
@@ -2510,9 +2538,8 @@ int i_APCI3120_InsnWriteDigitalOutput(struct comedi_device *dev,
 				      struct comedi_insn *insn,
 				      unsigned int *data)
 {
-
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp1;
-
 	unsigned int ui_NoOfChannel = CR_CHAN(insn->chanspec);	/*  get the channel */
 
 	if ((data[0] != 0) && (data[0] != 1)) {
@@ -2589,6 +2616,7 @@ int i_APCI3120_InsnWriteAnalogOutput(struct comedi_device *dev,
 				     struct comedi_insn *insn,
 				     unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Range, ui_Channel;
 	unsigned short us_TmpValue;
 
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index f9545b0..c082f14 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -546,8 +546,10 @@ int i_APCI3200_GetChannelCalibrationValue(struct comedi_device *dev,
 int i_APCI3200_ReadDigitalInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp = 0;
 	unsigned int ui_NoOfChannel = 0;
+
 	ui_NoOfChannel = CR_CHAN(insn->chanspec);
 	ui_Temp = data[0];
 	*data = inl(devpriv->i_IobaseReserved);
@@ -604,6 +606,7 @@ int i_APCI3200_ReadDigitalInput(struct comedi_device *dev, struct comedi_subdevi
 int i_APCI3200_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 
 	if ((data[0] != 0) && (data[0] != 1)) {
 		comedi_error(dev,
@@ -649,8 +652,10 @@ int i_APCI3200_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subd
 int i_APCI3200_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp = 0, ui_Temp1 = 0;
 	unsigned int ui_NoOfChannel = CR_CHAN(insn->chanspec);	/*  get the channel */
+
 	if (devpriv->b_OutputMemoryStatus) {
 		ui_Temp = inl(devpriv->i_IobaseAddon);
 
@@ -762,8 +767,10 @@ int i_APCI3200_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subde
 int i_APCI3200_ReadDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp;
 	unsigned int ui_NoOfChannel;
+
 	ui_NoOfChannel = CR_CHAN(insn->chanspec);
 	ui_Temp = data[0];
 	*data = inl(devpriv->i_IobaseAddon);
@@ -870,7 +877,7 @@ int i_APCI3200_ReadDigitalOutput(struct comedi_device *dev, struct comedi_subdev
 int i_APCI3200_ConfigAnalogInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
-
+	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Config = 0, ul_Temp = 0;
 	unsigned int ui_ChannelNo = 0;
 	unsigned int ui_Dummy = 0;
@@ -1647,6 +1654,7 @@ int i_APCI3200_ReadAnalogInput(struct comedi_device *dev, struct comedi_subdevic
 int i_APCI3200_Read1AnalogInputChannel(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_EOC = 0;
 	unsigned int ui_ChannelNo = 0;
 	unsigned int ui_CommandRegister = 0;
@@ -1771,6 +1779,7 @@ int i_APCI3200_Read1AnalogInputChannel(struct comedi_device *dev,
 */
 int i_APCI3200_ReadCalibrationOffsetValue(struct comedi_device *dev, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp = 0, ui_EOC = 0;
 	unsigned int ui_CommandRegister = 0;
 
@@ -1907,6 +1916,7 @@ int i_APCI3200_ReadCalibrationOffsetValue(struct comedi_device *dev, unsigned in
 */
 int i_APCI3200_ReadCalibrationGainValue(struct comedi_device *dev, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_EOC = 0;
 	int ui_CommandRegister = 0;
 
@@ -2043,6 +2053,7 @@ int i_APCI3200_ReadCalibrationGainValue(struct comedi_device *dev, unsigned int
 
 int i_APCI3200_ReadCJCValue(struct comedi_device *dev, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_EOC = 0;
 	int ui_CommandRegister = 0;
 
@@ -2162,8 +2173,10 @@ int i_APCI3200_ReadCJCValue(struct comedi_device *dev, unsigned int *data)
 */
 int i_APCI3200_ReadCJCCalOffset(struct comedi_device *dev, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_EOC = 0;
 	int ui_CommandRegister = 0;
+
   /*******************************************/
 	/*Read calibration offset value for the CJC */
   /*******************************************/
@@ -2278,8 +2291,10 @@ int i_APCI3200_ReadCJCCalOffset(struct comedi_device *dev, unsigned int *data)
 */
 int i_APCI3200_ReadCJCCalGain(struct comedi_device *dev, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_EOC = 0;
 	int ui_CommandRegister = 0;
+
   /*******************************/
 	/* Set the convert timing unit */
   /*******************************/
@@ -2400,8 +2415,10 @@ int i_APCI3200_ReadCJCCalGain(struct comedi_device *dev, unsigned int *data)
 int i_APCI3200_InsnBits_AnalogInput_Test(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Configuration = 0;
 	int i_Temp;		/* ,i_TimeUnit; */
+
 	/* if(i_Initialised==0) */
 
 	if (s_BoardInfos[dev->minor].i_Initialised == 0) {
@@ -2759,7 +2776,9 @@ int i_APCI3200_CommandTestAnalogInput(struct comedi_device *dev, struct comedi_s
 
 int i_APCI3200_StopCyclicAcquisition(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Configuration = 0;
+
 	/* i_InterruptFlag=0; */
 	/* i_Initialised=0; */
 	/* i_Count=0; */
@@ -2809,6 +2828,7 @@ int i_APCI3200_StopCyclicAcquisition(struct comedi_device *dev, struct comedi_su
 
 int i_APCI3200_CommandAnalogInput(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct addi_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	unsigned int ui_Configuration = 0;
 	/* INT  i_CurrentSource = 0; */
@@ -2821,6 +2841,7 @@ int i_APCI3200_CommandAnalogInput(struct comedi_device *dev, struct comedi_subde
 	unsigned int ui_DelayTime = 0;
 	unsigned int ui_DelayTimeBase = 0;
 	unsigned int ui_DelayMode = 0;
+
 	/* i_FirstChannel=cmd->chanlist[0]; */
 	/* i_LastChannel=cmd->chanlist[1]; */
 	s_BoardInfos[dev->minor].i_FirstChannel = cmd->chanlist[0];
@@ -2996,8 +3017,10 @@ int i_APCI3200_CommandAnalogInput(struct comedi_device *dev, struct comedi_subde
 
 int i_APCI3200_Reset(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_Temp;
 	unsigned int dw_Dummy;
+
 	/* i_InterruptFlag=0; */
 	/* i_Initialised==0; */
 	/* i_Count=0; */
@@ -3053,6 +3076,7 @@ int i_APCI3200_Reset(struct comedi_device *dev)
 void v_APCI3200_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_StatusRegister = 0;
 	unsigned int ui_ChannelNumber = 0;
 	int i_CalibrationFlag = 0;
@@ -3494,6 +3518,7 @@ void v_APCI3200_Interrupt(int irq, void *d)
 */
 int i_APCI3200_InterruptHandleEos(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_StatusRegister = 0;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index acaceb0..a730a4a 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -76,8 +76,10 @@ You should also find the complete GPL in the COPYING file accompanying this sour
 int i_APCI3501_ReadDigitalInput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp;
 	unsigned int ui_NoOfChannel;
+
 	ui_NoOfChannel = CR_CHAN(insn->chanspec);
 	ui_Temp = data[0];
 	*data = inl(devpriv->iobase + APCI3501_DIGITAL_IP);
@@ -124,6 +126,7 @@ int i_APCI3501_ReadDigitalInput(struct comedi_device *dev, struct comedi_subdevi
 int i_APCI3501_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 
 	if ((data[0] != 0) && (data[0] != 1)) {
 		comedi_error(dev,
@@ -164,8 +167,10 @@ int i_APCI3501_ConfigDigitalOutput(struct comedi_device *dev, struct comedi_subd
 int i_APCI3501_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp, ui_Temp1;
 	unsigned int ui_NoOfChannel = CR_CHAN(insn->chanspec);	/*  get the channel */
+
 	if (devpriv->b_OutputMemoryStatus) {
 		ui_Temp = inl(devpriv->iobase + APCI3501_DIGITAL_OP);
 	}			/* if(devpriv->b_OutputMemoryStatus ) */
@@ -251,6 +256,7 @@ int i_APCI3501_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subde
 int i_APCI3501_ReadDigitalOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Temp;
 	unsigned int ui_NoOfChannel;
 
@@ -301,6 +307,8 @@ int i_APCI3501_ReadDigitalOutput(struct comedi_device *dev, struct comedi_subdev
 int i_APCI3501_ConfigAnalogOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
+
 	outl(data[0],
 		devpriv->iobase + APCI3501_ANALOG_OUTPUT +
 		APCI3501_AO_VOLT_MODE);
@@ -339,6 +347,7 @@ int i_APCI3501_ConfigAnalogOutput(struct comedi_device *dev, struct comedi_subde
 int i_APCI3501_WriteAnalogOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0, ul_Channel_no, ul_Polarity, ul_DAC_Ready = 0;
 
 	ul_Channel_no = CR_CHAN(insn->chanspec);
@@ -413,7 +422,9 @@ int i_APCI3501_WriteAnalogOutput(struct comedi_device *dev, struct comedi_subdev
 int i_APCI3501_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
+
 	devpriv->tsk_Current = current;
 	if (data[0] == ADDIDATA_WATCHDOG) {
 
@@ -514,8 +525,10 @@ int i_APCI3501_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 int i_APCI3501_StartStopWriteTimerCounterWatchdog(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
 	int i_Temp;
+
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 
 		if (data[1] == 1) {
@@ -616,6 +629,7 @@ int i_APCI3501_StartStopWriteTimerCounterWatchdog(struct comedi_device *dev,
 int i_APCI3501_ReadTimerCounterWatchdog(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn, unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 		data[0] =
@@ -656,8 +670,10 @@ int i_APCI3501_ReadTimerCounterWatchdog(struct comedi_device *dev,
 
 int i_APCI3501_Reset(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_Count = 0, i_temp = 0;
 	unsigned int ul_Command1 = 0, ul_Polarity, ul_DAC_Ready = 0;
+
 	outl(0x0, devpriv->iobase + APCI3501_DIGITAL_OP);
 	outl(1, devpriv->iobase + APCI3501_ANALOG_OUTPUT +
 		APCI3501_AO_VOLT_MODE);
@@ -709,8 +725,10 @@ void v_APCI3501_Interrupt(int irq, void *d)
 {
 	int i_temp;
 	struct comedi_device *dev = d;
+	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Timer_AOWatchdog;
 	unsigned long ul_Command1;
+
 	/*  Disable Interrupt */
 	ul_Command1 =
 		inl(devpriv->iobase + APCI3501_WATCHDOG + APCI3501_TCW_PROG);
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
index fff99df..80974f2 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
@@ -69,6 +69,8 @@ You should also find the complete GPL in the COPYING file accompanying this sour
 */
 static int i_APCI3XXX_TestConversionStarted(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
+
 	if ((readl(devpriv->dw_AiBase + 8) & 0x80000UL) == 0x80000UL)
 		return 1;
 	else
@@ -108,6 +110,8 @@ static int i_APCI3XXX_AnalogInputConfigOperatingMode(struct comedi_device *dev,
 						     struct comedi_insn *insn,
 						     unsigned int *data)
 {
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
 	int i_ReturnValue = insn->n;
 	unsigned char b_TimeBase = 0;
 	unsigned char b_SingleDiff = 0;
@@ -358,6 +362,8 @@ static int i_APCI3XXX_InsnReadAnalogInput(struct comedi_device *dev,
 					  struct comedi_insn *insn,
 					  unsigned int *data)
 {
+	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
 	int i_ReturnValue = insn->n;
 	unsigned char b_Configuration = (unsigned char) CR_RANGE(insn->chanspec);
 	unsigned char b_Channel = (unsigned char) CR_CHAN(insn->chanspec);
@@ -571,6 +577,7 @@ static int i_APCI3XXX_InsnReadAnalogInput(struct comedi_device *dev,
 static void v_APCI3XXX_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct addi_private *devpriv = dev->private;
 	unsigned char b_CopyCpt = 0;
 	unsigned int dw_Status = 0;
 
@@ -651,6 +658,7 @@ static int i_APCI3XXX_InsnWriteAnalogOutput(struct comedi_device *dev,
 					    struct comedi_insn *insn,
 					    unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned char b_Range = (unsigned char) CR_RANGE(insn->chanspec);
 	unsigned char b_Channel = (unsigned char) CR_CHAN(insn->chanspec);
 	unsigned int dw_Status = 0;
@@ -755,6 +763,7 @@ static int i_APCI3XXX_InsnConfigInitTTLIO(struct comedi_device *dev,
 					  struct comedi_insn *insn,
 					  unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_ReturnValue = insn->n;
 	unsigned char b_Command = 0;
 
@@ -884,6 +893,7 @@ static int i_APCI3XXX_InsnBitsTTLIO(struct comedi_device *dev,
 				    struct comedi_insn *insn,
 				    unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_ReturnValue = insn->n;
 	unsigned char b_ChannelCpt = 0;
 	unsigned int dw_ChannelMask = 0;
@@ -1040,6 +1050,7 @@ static int i_APCI3XXX_InsnReadTTLIO(struct comedi_device *dev,
 				    struct comedi_insn *insn,
 				    unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned char b_Channel = (unsigned char) CR_CHAN(insn->chanspec);
 	int i_ReturnValue = insn->n;
 	unsigned int *pls_ReadData = data;
@@ -1154,6 +1165,7 @@ static int i_APCI3XXX_InsnWriteTTLIO(struct comedi_device *dev,
 				     struct comedi_insn *insn,
 				     unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_ReturnValue = insn->n;
 	unsigned char b_Channel = (unsigned char) CR_CHAN(insn->chanspec);
 	unsigned char b_State = 0;
@@ -1267,6 +1279,7 @@ static int i_APCI3XXX_InsnReadDigitalInput(struct comedi_device *dev,
 					   struct comedi_insn *insn,
 					   unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_ReturnValue = insn->n;
 	unsigned char b_Channel = (unsigned char) CR_CHAN(insn->chanspec);
 	unsigned int dw_Temp = 0;
@@ -1327,6 +1340,7 @@ static int i_APCI3XXX_InsnBitsDigitalInput(struct comedi_device *dev,
 					   struct comedi_insn *insn,
 					   unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_ReturnValue = insn->n;
 	unsigned int dw_Temp = 0;
 
@@ -1382,6 +1396,7 @@ static int i_APCI3XXX_InsnBitsDigitalOutput(struct comedi_device *dev,
 					    struct comedi_insn *insn,
 					    unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_ReturnValue = insn->n;
 	unsigned char b_ChannelCpt = 0;
 	unsigned int dw_ChannelMask = 0;
@@ -1480,6 +1495,7 @@ static int i_APCI3XXX_InsnWriteDigitalOutput(struct comedi_device *dev,
 					     struct comedi_insn *insn,
 					     unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_ReturnValue = insn->n;
 	unsigned char b_Channel = CR_CHAN(insn->chanspec);
 	unsigned char b_State = 0;
@@ -1557,6 +1573,7 @@ static int i_APCI3XXX_InsnReadDigitalOutput(struct comedi_device *dev,
 					    struct comedi_insn *insn,
 					    unsigned int *data)
 {
+	struct addi_private *devpriv = dev->private;
 	int i_ReturnValue = insn->n;
 	unsigned char b_Channel = CR_CHAN(insn->chanspec);
 	unsigned int dw_Status = 0;
@@ -1614,6 +1631,7 @@ static int i_APCI3XXX_InsnReadDigitalOutput(struct comedi_device *dev,
 
 static int i_APCI3XXX_Reset(struct comedi_device *dev)
 {
+	struct addi_private *devpriv = dev->private;
 	unsigned char b_Cpt = 0;
 
 	/*************************/
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 9db36f5..6b12adc 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -363,8 +363,6 @@ struct pci9111_private_data {
 	short ai_bounce_buffer[2 * PCI9111_FIFO_HALF_SIZE];
 };
 
-#define dev_private	((struct pci9111_private_data *)dev->private)
-
 /*  ------------------------------------------------------------------ */
 /*  PLX9050 SECTION */
 /*  ------------------------------------------------------------------ */
@@ -412,6 +410,8 @@ static void plx9050_interrupt_control(unsigned long io_base,
 
 static void pci9111_timer_set(struct comedi_device *dev)
 {
+	struct pci9111_private_data *dev_private = dev->private;
+
 	pci9111_8254_control_set(PCI9111_8254_COUNTER_0 |
 				 PCI9111_8254_READ_LOAD_LSB_MSB |
 				 PCI9111_8254_MODE_0 |
@@ -525,6 +525,8 @@ static void pci9111_interrupt_source_set(struct comedi_device *dev,
 static int pci9111_ai_cancel(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
+	struct pci9111_private_data *dev_private = dev->private;
+
 	/*  Disable interrupts */
 
 	plx9050_interrupt_control(dev_private->lcr_io_base, true, true, true,
@@ -556,11 +558,12 @@ static int
 pci9111_ai_do_cmd_test(struct comedi_device *dev,
 		       struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
+	const struct pci9111_board *board = comedi_board(dev);
+	struct pci9111_private_data *dev_private = dev->private;
 	int tmp;
 	int error = 0;
 	int range, reference;
 	int i;
-	struct pci9111_board *board = (struct pci9111_board *)dev->board_ptr;
 
 	/*  Step 1 : check if trigger are trivialy valid */
 
@@ -756,6 +759,7 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 static int pci9111_ai_do_cmd(struct comedi_device *dev,
 			     struct comedi_subdevice *subdevice)
 {
+	struct pci9111_private_data *dev_private = dev->private;
 	struct comedi_cmd *async_cmd = &subdevice->async->cmd;
 
 	if (!dev->irq) {
@@ -881,10 +885,10 @@ static void pci9111_ai_munge(struct comedi_device *dev,
 			     unsigned int num_bytes,
 			     unsigned int start_chan_index)
 {
+	const struct pci9111_board *board = comedi_board(dev);
 	unsigned int i, num_samples = num_bytes / sizeof(short);
 	short *array = data;
-	int resolution =
-	    ((struct pci9111_board *)dev->board_ptr)->ai_resolution;
+	int resolution = board->ai_resolution;
 
 	for (i = 0; i < num_samples; i++) {
 		if (resolution == PCI9111_HR_AI_RESOLUTION)
@@ -907,6 +911,7 @@ static void pci9111_ai_munge(struct comedi_device *dev,
 static irqreturn_t pci9111_interrupt(int irq, void *p_device)
 {
 	struct comedi_device *dev = p_device;
+	struct pci9111_private_data *dev_private = dev->private;
 	struct comedi_subdevice *subdevice = dev->read_subdev;
 	struct comedi_async *async;
 	unsigned long irq_flags;
@@ -1056,8 +1061,8 @@ static int pci9111_ai_insn_read(struct comedi_device *dev,
 				struct comedi_subdevice *subdevice,
 				struct comedi_insn *insn, unsigned int *data)
 {
-	int resolution =
-	    ((struct pci9111_board *)dev->board_ptr)->ai_resolution;
+	const struct pci9111_board *board = comedi_board(dev);
+	int resolution = board->ai_resolution;
 
 	int timeout, i;
 
@@ -1113,6 +1118,7 @@ pci9111_ao_insn_write(struct comedi_device *dev,
 		      struct comedi_subdevice *s, struct comedi_insn *insn,
 		      unsigned int *data)
 {
+	struct pci9111_private_data *dev_private = dev->private;
 	int i;
 
 	for (i = 0; i < insn->n; i++) {
@@ -1129,6 +1135,7 @@ static int pci9111_ao_insn_read(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci9111_private_data *dev_private = dev->private;
 	int i;
 
 	for (i = 0; i < insn->n; i++)
@@ -1189,6 +1196,8 @@ static int pci9111_do_insn_bits(struct comedi_device *dev,
 
 static int pci9111_reset(struct comedi_device *dev)
 {
+	struct pci9111_private_data *dev_private = dev->private;
+
 	/*  Set trigger source to software */
 
 	plx9050_interrupt_control(dev_private->lcr_io_base, true, true, true,
@@ -1246,13 +1255,16 @@ static struct pci_dev *pci9111_find_pci(struct comedi_device *dev,
 static int pci9111_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct pci9111_board *board;
+	struct pci9111_private_data *dev_private;
 	struct comedi_subdevice *subdevice;
 	unsigned long io_base, io_range, lcr_io_base, lcr_io_range;
 	int error;
-	const struct pci9111_board *board;
 
-	if (alloc_private(dev, sizeof(struct pci9111_private_data)) < 0)
+	if (alloc_private(dev, sizeof(*dev_private)) < 0)
 		return -ENOMEM;
+	dev_private = dev->private;
+
 	/*  Probe the device to determine what device in the series it is. */
 
 	printk(KERN_ERR "comedi%d: " PCI9111_DRIVER_NAME " driver\n",
@@ -1261,7 +1273,7 @@ static int pci9111_attach(struct comedi_device *dev,
 	dev->pcidev = pci9111_find_pci(dev, it);
 	if (!dev->pcidev)
 		return -EIO;
-	board = (struct pci9111_board *)dev->board_ptr;
+	board = comedi_board(dev);
 
 	/*  TODO: Warn about non-tested boards. */
 
@@ -1373,7 +1385,9 @@ static int pci9111_attach(struct comedi_device *dev,
 
 static void pci9111_detach(struct comedi_device *dev)
 {
-	if (dev->private != NULL) {
+	struct pci9111_private_data *dev_private = dev->private;
+
+	if (dev_private) {
 		if (dev_private->is_valid)
 			pci9111_reset(dev);
 	}
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index deda411..95cecbd 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -356,9 +356,6 @@ struct pci9118_private {
 	unsigned int ai_inttrig_start;	/* TRIG_INT for start */
 };
 
-#define devpriv ((struct pci9118_private *)dev->private)
-#define this_board ((struct boardtype *)dev->board_ptr)
-
 /*
 ==============================================================================
 */
@@ -392,7 +389,7 @@ static int pci9118_insn_read_ai(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
-
+	struct pci9118_private *devpriv = dev->private;
 	int n, timeout;
 
 	devpriv->AdControlReg = AdControl_Int & 0xff;
@@ -449,6 +446,7 @@ static int pci9118_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci9118_private *devpriv = dev->private;
 	int n, chanreg, ch;
 
 	ch = CR_CHAN(insn->chanspec);
@@ -473,6 +471,7 @@ static int pci9118_insn_read_ao(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci9118_private *devpriv = dev->private;
 	int n, chan;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -516,6 +515,8 @@ static int pci9118_insn_bits_do(struct comedi_device *dev,
 */
 static void interrupt_pci9118_ai_mode4_switch(struct comedi_device *dev)
 {
+	struct pci9118_private *devpriv = dev->private;
+
 	devpriv->AdFunctionReg =
 	    AdFunction_PDTrg | AdFunction_PETrg | AdFunction_AM;
 	outl(devpriv->AdFunctionReg, dev->iobase + PCI9118_ADFUNC);
@@ -533,6 +534,7 @@ static unsigned int defragment_dma_buffer(struct comedi_device *dev,
 					  short *dma_buffer,
 					  unsigned int num_samples)
 {
+	struct pci9118_private *devpriv = dev->private;
 	unsigned int i = 0, j = 0;
 	unsigned int start_pos = devpriv->ai_add_front,
 	    stop_pos = devpriv->ai_add_front + devpriv->ai_n_chan;
@@ -559,6 +561,7 @@ static int move_block_from_dma(struct comedi_device *dev,
 					short *dma_buffer,
 					unsigned int num_samples)
 {
+	struct pci9118_private *devpriv = dev->private;
 	unsigned int num_bytes;
 
 	num_samples = defragment_dma_buffer(dev, s, dma_buffer, num_samples);
@@ -581,6 +584,8 @@ static char pci9118_decode_error_status(struct comedi_device *dev,
 					struct comedi_subdevice *s,
 					unsigned char m)
 {
+	struct pci9118_private *devpriv = dev->private;
+
 	if (m & 0x100) {
 		comedi_error(dev, "A/D FIFO Full status (Fatal Error!)");
 		devpriv->ai_maskerr &= ~0x100L;
@@ -613,6 +618,7 @@ static void pci9118_ai_munge(struct comedi_device *dev,
 			     unsigned int num_bytes,
 			     unsigned int start_chan_index)
 {
+	struct pci9118_private *devpriv = dev->private;
 	unsigned int i, num_samples = num_bytes / sizeof(short);
 	short *array = data;
 
@@ -636,6 +642,7 @@ static void interrupt_pci9118_ai_onesample(struct comedi_device *dev,
 					   unsigned int int_amcc,
 					   unsigned short int_daq)
 {
+	struct pci9118_private *devpriv = dev->private;
 	register short sampl;
 
 	s->async->events = 0;
@@ -689,6 +696,7 @@ static void interrupt_pci9118_ai_dma(struct comedi_device *dev,
 				     unsigned int int_amcc,
 				     unsigned short int_daq)
 {
+	struct pci9118_private *devpriv = dev->private;
 	unsigned int next_dma_buf, samplesinbuf, sampls, m;
 
 	if (int_amcc & MASTER_ABORT_INT) {
@@ -774,6 +782,7 @@ static void interrupt_pci9118_ai_dma(struct comedi_device *dev,
 static irqreturn_t interrupt_pci9118(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct pci9118_private *devpriv = dev->private;
 	unsigned int int_daq = 0, int_amcc, int_adstat;
 
 	if (!dev->attached)
@@ -850,6 +859,8 @@ static irqreturn_t interrupt_pci9118(int irq, void *d)
 static int pci9118_ai_inttrig(struct comedi_device *dev,
 			      struct comedi_subdevice *s, unsigned int trignum)
 {
+	struct pci9118_private *devpriv = dev->private;
+
 	if (trignum != devpriv->ai_inttrig_start)
 		return -EINVAL;
 
@@ -875,6 +886,8 @@ static int pci9118_ai_cmdtest(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_cmd *cmd)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci9118_private *devpriv = dev->private;
 	int err = 0;
 	int tmp;
 	unsigned int divisor1 = 0, divisor2 = 0;
@@ -1136,6 +1149,7 @@ static int pci9118_ai_cmdtest(struct comedi_device *dev,
 */
 static int Compute_and_setup_dma(struct comedi_device *dev)
 {
+	struct pci9118_private *devpriv = dev->private;
 	unsigned int dmalen0, dmalen1, i;
 
 	DPRINTK("adl_pci9118 EDBG: BGN: Compute_and_setup_dma()\n");
@@ -1277,6 +1291,8 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 
 	DPRINTK("5 dmalen0=%d dmalen1=%d\n", dmalen0, dmalen1);
 #if 0
+	{
+	const struct boardtype *this_board = comedi_board(dev);
 	if (devpriv->ai_n_scanlen < this_board->half_fifo_size) {
 		devpriv->dmabuf_panic_size[0] =
 		    (this_board->half_fifo_size / devpriv->ai_n_scanlen +
@@ -1290,6 +1306,7 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 		devpriv->dmabuf_panic_size[1] =
 		    (devpriv->ai_n_scanlen << 1) % devpriv->dmabuf_size[1];
 	}
+	}
 #endif
 
 	outl(inl(devpriv->iobase_a + AMCC_OP_REG_MCSR) & (~EN_A2P_TRANSFERS),
@@ -1318,6 +1335,8 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 static int pci9118_ai_docmd_sampl(struct comedi_device *dev,
 				  struct comedi_subdevice *s)
 {
+	struct pci9118_private *devpriv = dev->private;
+
 	DPRINTK("adl_pci9118 EDBG: BGN: pci9118_ai_docmd_sampl(%d,) [%d]\n",
 		dev->minor, devpriv->ai_do);
 	switch (devpriv->ai_do) {
@@ -1376,6 +1395,8 @@ static int pci9118_ai_docmd_sampl(struct comedi_device *dev,
 static int pci9118_ai_docmd_dma(struct comedi_device *dev,
 				struct comedi_subdevice *s)
 {
+	struct pci9118_private *devpriv = dev->private;
+
 	DPRINTK("adl_pci9118 EDBG: BGN: pci9118_ai_docmd_dma(%d,) [%d,%d]\n",
 		dev->minor, devpriv->ai_do, devpriv->usedma);
 	Compute_and_setup_dma(dev);
@@ -1449,6 +1470,8 @@ static int pci9118_ai_docmd_dma(struct comedi_device *dev,
 */
 static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci9118_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	unsigned int addchans = 0;
 	int ret = 0;
@@ -1699,6 +1722,8 @@ static int check_channel_list(struct comedi_device *dev,
 			      struct comedi_subdevice *s, int n_chan,
 			      unsigned int *chanlist, int frontadd, int backadd)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci9118_private *devpriv = dev->private;
 	unsigned int i, differencial = 0, bipolar = 0;
 
 	/* correct channel and range number check itself comedi/range.c */
@@ -1754,6 +1779,7 @@ static int setup_channel_list(struct comedi_device *dev,
 			      unsigned int *chanlist, int rot, int frontadd,
 			      int backadd, int usedma, char useeos)
 {
+	struct pci9118_private *devpriv = dev->private;
 	unsigned int i, differencial = 0, bipolar = 0;
 	unsigned int scanquad, gain, ssh = 0x00;
 
@@ -1887,6 +1913,9 @@ static void pci9118_calc_divisors(char mode, struct comedi_device *dev,
 				  unsigned int *div1, unsigned int *div2,
 				  char usessh, unsigned int chnsshfront)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci9118_private *devpriv = dev->private;
+
 	DPRINTK
 	    ("adl_pci9118 EDBG: BGN: pci9118_calc_divisors"
 					"(%d,%d,.,%u,%u,%u,%d,.,.,,%u,%u)\n",
@@ -1967,6 +1996,8 @@ static void start_pacer(struct comedi_device *dev, int mode,
 */
 static int pci9118_exttrg_add(struct comedi_device *dev, unsigned char source)
 {
+	struct pci9118_private *devpriv = dev->private;
+
 	if (source > 3)
 		return -1;				/* incorrect source */
 	devpriv->exttrg_users |= (1 << source);
@@ -1983,6 +2014,8 @@ static int pci9118_exttrg_add(struct comedi_device *dev, unsigned char source)
 */
 static int pci9118_exttrg_del(struct comedi_device *dev, unsigned char source)
 {
+	struct pci9118_private *devpriv = dev->private;
+
 	if (source > 3)
 		return -1;			/* incorrect source */
 	devpriv->exttrg_users &= ~(1 << source);
@@ -2004,6 +2037,8 @@ static int pci9118_exttrg_del(struct comedi_device *dev, unsigned char source)
 static int pci9118_ai_cancel(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
+	struct pci9118_private *devpriv = dev->private;
+
 	if (devpriv->usedma)
 		outl(inl(devpriv->iobase_a + AMCC_OP_REG_MCSR) &
 			(~EN_A2P_TRANSFERS),
@@ -2053,6 +2088,8 @@ static int pci9118_ai_cancel(struct comedi_device *dev,
 */
 static int pci9118_reset(struct comedi_device *dev)
 {
+	struct pci9118_private *devpriv = dev->private;
+
 	devpriv->IntControlReg = 0;
 	devpriv->exttrg_users = 0;
 	inl(dev->iobase + PCI9118_INTCTRL);
@@ -2112,6 +2149,7 @@ static int pci9118_reset(struct comedi_device *dev)
 static struct pci_dev *pci9118_find_pci(struct comedi_device *dev,
 					struct comedi_devconfig *it)
 {
+	const struct boardtype *this_board = comedi_board(dev);
 	struct pci_dev *pcidev = NULL;
 	int bus = it->options[0];
 	int slot = it->options[1];
@@ -2150,6 +2188,8 @@ static struct pci_dev *pci9118_find_pci(struct comedi_device *dev,
 static int pci9118_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci9118_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret, pages, i;
 	unsigned short master;
@@ -2163,11 +2203,12 @@ static int pci9118_attach(struct comedi_device *dev,
 	else
 		master = 1;
 
-	ret = alloc_private(dev, sizeof(struct pci9118_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0) {
 		printk(" - Allocation failed!\n");
 		return -ENOMEM;
 	}
+	devpriv = dev->private;
 
 	dev->pcidev = pci9118_find_pci(dev, it);
 	if (!dev->pcidev)
@@ -2342,7 +2383,9 @@ static int pci9118_attach(struct comedi_device *dev,
 
 static void pci9118_detach(struct comedi_device *dev)
 {
-	if (dev->private) {
+	struct pci9118_private *devpriv = dev->private;
+
+	if (devpriv) {
 		if (devpriv->valid)
 			pci9118_reset(dev);
 		if (dev->irq)
diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index 6df51c8..c0140a4 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -133,8 +133,6 @@ struct adq12b_private {
 	unsigned int digital_state;
 };
 
-#define devpriv ((struct adq12b_private *)dev->private)
-
 /*
  * "instructions" read/write data in "one-shot" or "software-triggered"
  * mode.
@@ -144,6 +142,7 @@ static int adq12b_ai_rinsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
 {
+	struct adq12b_private *devpriv = dev->private;
 	int n, i;
 	int range, channel;
 	unsigned char hi, lo, status;
@@ -200,6 +199,7 @@ static int adq12b_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct adq12b_private *devpriv = dev->private;
 	int channel;
 
 	for (channel = 0; channel < 8; channel++)
@@ -221,6 +221,7 @@ static int adq12b_do_insn_bits(struct comedi_device *dev,
 static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct adq12b_board *board = comedi_board(dev);
+	struct adq12b_private *devpriv;
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	int unipolar, differential;
@@ -256,8 +257,9 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * Allocate the private structure area.  alloc_private() is a
  * convenient macro defined in comedidev.h.
  */
-	if (alloc_private(dev, sizeof(struct adq12b_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 /* fill in devpriv structure */
 	devpriv->unipolar = unipolar;
@@ -319,6 +321,8 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void adq12b_detach(struct comedi_device *dev)
 {
+	struct adq12b_private *devpriv = dev->private;
+
 	if (dev->iobase)
 		release_region(dev->iobase, ADQ12B_SIZE);
 	kfree(devpriv);
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 0ed1ff9..f4b7c5b 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -279,9 +279,6 @@ struct pci1710_private {
 					 * internal state */
 };
 
-#define devpriv ((struct pci1710_private *)dev->private)
-#define this_board ((const struct boardtype *)dev->board_ptr)
-
 /*
 ==============================================================================
 */
@@ -314,6 +311,8 @@ static int pci171x_insn_read_ai(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
 	int n, timeout;
 #ifdef PCI171x_PARANOIDCHECK
 	unsigned int idata;
@@ -385,6 +384,7 @@ static int pci171x_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci1710_private *devpriv = dev->private;
 	int n, chan, range, ofs;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -417,6 +417,7 @@ static int pci171x_insn_read_ao(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci1710_private *devpriv = dev->private;
 	int n, chan;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -487,6 +488,7 @@ static int pci171x_insn_counter_write(struct comedi_device *dev,
 				      struct comedi_insn *insn,
 				      unsigned int *data)
 {
+	struct pci1710_private *devpriv = dev->private;
 	uint msb, lsb, ccntrl, status;
 
 	lsb = data[0] & 0x00FF;
@@ -517,6 +519,8 @@ static int pci171x_insn_counter_config(struct comedi_device *dev,
 				       unsigned int *data)
 {
 #ifdef unused
+	struct pci1710_private *devpriv = dev->private;
+
 	/* This doesn't work like a normal Comedi counter config */
 	uint ccntrl = 0;
 
@@ -553,6 +557,7 @@ static int pci1720_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci1710_private *devpriv = dev->private;
 	int n, rangereg, chan;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -579,6 +584,8 @@ static int pci1720_insn_write_ao(struct comedi_device *dev,
 static void interrupt_pci1710_every_sample(void *d)
 {
 	struct comedi_device *dev = d;
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	int m;
 #ifdef PCI171x_PARANOIDCHECK
@@ -670,6 +677,8 @@ static void interrupt_pci1710_every_sample(void *d)
 static int move_block_from_fifo(struct comedi_device *dev,
 				struct comedi_subdevice *s, int n, int turn)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
 	int i, j;
 #ifdef PCI171x_PARANOIDCHECK
 	int sampl;
@@ -716,6 +725,8 @@ static int move_block_from_fifo(struct comedi_device *dev,
 static void interrupt_pci1710_half_fifo(void *d)
 {
 	struct comedi_device *dev = d;
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	int m, samplesinbuf;
 
@@ -772,6 +783,7 @@ static void interrupt_pci1710_half_fifo(void *d)
 static irqreturn_t interrupt_service_pci1710(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct pci1710_private *devpriv = dev->private;
 
 	DPRINTK("adv_pci1710 EDBG: BGN: interrupt_service_pci1710(%d,...)\n",
 		irq);
@@ -813,6 +825,8 @@ static irqreturn_t interrupt_service_pci1710(int irq, void *d)
 static int pci171x_ai_docmd_and_mode(int mode, struct comedi_device *dev,
 				     struct comedi_subdevice *s)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
 	unsigned int divisor1 = 0, divisor2 = 0;
 	unsigned int seglen;
 
@@ -917,6 +931,8 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_cmd *cmd)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
 	int err = 0;
 	int tmp;
 	unsigned int divisor1 = 0, divisor2 = 0;
@@ -1082,6 +1098,7 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 */
 static int pci171x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct pci1710_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
 	DPRINTK("adv_pci1710 EDBG: BGN: pci171x_ai_cmd(...)\n");
@@ -1178,6 +1195,8 @@ static void setup_channel_list(struct comedi_device *dev,
 			       unsigned int *chanlist, unsigned int n_chan,
 			       unsigned int seglen)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
 	unsigned int i, range, chanprog;
 
 	DPRINTK("adv_pci1710 EDBG:  setup_channel_list(...,%d,%d)\n", n_chan,
@@ -1242,6 +1261,9 @@ static void start_pacer(struct comedi_device *dev, int mode,
 static int pci171x_ai_cancel(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
+
 	DPRINTK("adv_pci1710 EDBG: BGN: pci171x_ai_cancel(...)\n");
 
 	switch (this_board->cardtype) {
@@ -1271,6 +1293,9 @@ static int pci171x_ai_cancel(struct comedi_device *dev,
 */
 static int pci171x_reset(struct comedi_device *dev)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv = dev->private;
+
 	DPRINTK("adv_pci1710 EDBG: BGN: pci171x_reset(...)\n");
 	outw(0x30, dev->iobase + PCI171x_CNTCTRL);
 	devpriv->CntrlReg = Control_SW | Control_CNT0;	/*  Software trigger, CNT0=external */
@@ -1301,6 +1326,8 @@ static int pci171x_reset(struct comedi_device *dev)
 */
 static int pci1720_reset(struct comedi_device *dev)
 {
+	struct pci1710_private *devpriv = dev->private;
+
 	DPRINTK("adv_pci1710 EDBG: BGN: pci1720_reset(...)\n");
 	outb(Syncont_SC0, dev->iobase + PCI1720_SYNCONT);	/*  set synchronous output mode */
 	devpriv->da_ranges = 0xAA;
@@ -1323,6 +1350,8 @@ static int pci1720_reset(struct comedi_device *dev)
 */
 static int pci1710_reset(struct comedi_device *dev)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+
 	DPRINTK("adv_pci1710 EDBG: BGN: pci1710_reset(...)\n");
 	switch (this_board->cardtype) {
 	case TYPE_PCI1720:
@@ -1336,6 +1365,8 @@ static int pci1710_reset(struct comedi_device *dev)
 static int pci1710_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct pci1710_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret, subdev, n_subdevices;
 	unsigned int irq;
@@ -1352,9 +1383,10 @@ static int pci1710_attach(struct comedi_device *dev,
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
 
-	ret = alloc_private(dev, sizeof(struct pci1710_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	/* Look for matching PCI device */
 	errstr = "not found!";
@@ -1394,6 +1426,7 @@ static int pci1710_attach(struct comedi_device *dev,
 		}
 		/*  fixup board_ptr in case we were using the dummy entry with the driver name */
 		dev->board_ptr = &boardtypes[board_index];
+		this_board = comedi_board(dev);
 		break;
 	}
 
@@ -1552,7 +1585,9 @@ static int pci1710_attach(struct comedi_device *dev,
 
 static void pci1710_detach(struct comedi_device *dev)
 {
-	if (dev->private) {
+	struct pci1710_private *devpriv = dev->private;
+
+	if (devpriv) {
 		if (devpriv->valid)
 			pci1710_reset(dev);
 		if (dev->irq)
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index 5c99c74..9a752cb 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -158,16 +158,12 @@ struct pci1723_private {
 	short ao_data[8];	/* data output buffer */
 };
 
-/* The following macro to make it easy to access the private structure. */
-#define devpriv ((struct pci1723_private *)dev->private)
-
-#define this_board boardtypes
-
 /*
  * The pci1723 card reset;
  */
 static int pci1723_reset(struct comedi_device *dev)
 {
+	struct pci1723_private *devpriv = dev->private;
 	int i;
 	DPRINTK("adv_pci1723 EDBG: BGN: pci1723_reset(...)\n");
 
@@ -199,6 +195,7 @@ static int pci1723_insn_read_ao(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci1723_private *devpriv = dev->private;
 	int n, chan;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -216,6 +213,7 @@ static int pci1723_ao_write_winsn(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci1723_private *devpriv = dev->private;
 	int n, chan;
 	chan = CR_CHAN(insn->chanspec);
 
@@ -290,6 +288,8 @@ static int pci1723_dio_insn_bits(struct comedi_device *dev,
 static int pci1723_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct pci1723_board *this_board;
+	struct pci1723_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret, subdev, n_subdevices;
 	struct pci_dev *pcidev;
@@ -298,17 +298,21 @@ static int pci1723_attach(struct comedi_device *dev,
 	int opt_bus, opt_slot;
 	const char *errstr;
 
+	dev->board_ptr = boardtypes;
+	this_board = comedi_board(dev);
+
 	printk(KERN_ERR "comedi%d: adv_pci1723: board=%s",
 						dev->minor, this_board->name);
 
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
 
-	ret = alloc_private(dev, sizeof(struct pci1723_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0) {
 		printk(" - Allocation failed!\n");
 		return -ENOMEM;
 	}
+	devpriv = dev->private;
 
 	/* Look for matching PCI device */
 	errstr = "not found!";
@@ -429,7 +433,9 @@ static int pci1723_attach(struct comedi_device *dev,
 
 static void pci1723_detach(struct comedi_device *dev)
 {
-	if (dev->private) {
+	struct pci1723_private *devpriv = dev->private;
+
+	if (devpriv) {
 		if (devpriv->valid)
 			pci1723_reset(dev);
 		if (devpriv->pcidev) {
diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index ad653a5..35aef80 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -406,9 +406,6 @@ struct pci_dio_private {
 
 static struct pci_dio_private *pci_priv;	/* list of allocated cards */
 
-#define devpriv ((struct pci_dio_private *)dev->private)
-#define this_board ((const struct dio_boardtype *)dev->board_ptr)
-
 /*
 ==============================================================================
 */
@@ -699,6 +696,7 @@ static int pci1760_insn_cnt_write(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci_dio_private *devpriv = dev->private;
 	int ret;
 	unsigned char chan = CR_CHAN(insn->chanspec) & 0x07;
 	unsigned char bitmask = 1 << chan;
@@ -741,6 +739,7 @@ static int pci1760_insn_cnt_write(struct comedi_device *dev,
 */
 static int pci1760_reset(struct comedi_device *dev)
 {
+	struct pci_dio_private *devpriv = dev->private;
 	int i;
 	unsigned char omb[4] = { 0x00, 0x00, 0x00, 0x00 };
 	unsigned char imb[4];
@@ -821,6 +820,8 @@ static int pci1760_reset(struct comedi_device *dev)
 */
 static int pci_dio_reset(struct comedi_device *dev)
 {
+	const struct dio_boardtype *this_board = comedi_board(dev);
+
 	DPRINTK("adv_pci_dio EDBG: BGN: pci171x_reset(...)\n");
 
 	switch (this_board->cardtype) {
@@ -986,6 +987,8 @@ static int pci1760_attach(struct comedi_device *dev,
 static int pci_dio_add_di(struct comedi_device *dev, struct comedi_subdevice *s,
 			  const struct diosubd_data *d, int subdev)
 {
+	const struct dio_boardtype *this_board = comedi_board(dev);
+
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_COMMON | d->specflags;
 	if (d->chans > 16)
@@ -1013,6 +1016,8 @@ static int pci_dio_add_di(struct comedi_device *dev, struct comedi_subdevice *s,
 static int pci_dio_add_do(struct comedi_device *dev, struct comedi_subdevice *s,
 			  const struct diosubd_data *d, int subdev)
 {
+	const struct dio_boardtype *this_board = comedi_board(dev);
+
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
 	if (d->chans > 16)
@@ -1062,6 +1067,7 @@ static int CheckAndAllocCard(struct comedi_device *dev,
 			     struct comedi_devconfig *it,
 			     struct pci_dev *pcidev)
 {
+	struct pci_dio_private *devpriv = dev->private;
 	struct pci_dio_private *pr, *prev;
 
 	for (pr = pci_priv, prev = NULL; pr != NULL; prev = pr, pr = pr->next) {
@@ -1085,15 +1091,18 @@ static int CheckAndAllocCard(struct comedi_device *dev,
 static int pci_dio_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct dio_boardtype *this_board;
+	struct pci_dio_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret, subdev, n_subdevices, i, j;
 	unsigned long iobase;
 	struct pci_dev *pcidev = NULL;
 
 
-	ret = alloc_private(dev, sizeof(struct pci_dio_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	for_each_pci_dev(pcidev) {
 		/*  loop through cards supported by this driver */
@@ -1114,6 +1123,7 @@ static int pci_dio_attach(struct comedi_device *dev,
 			if (ret != 1)
 				continue;
 			dev->board_ptr = boardtypes + i;
+			this_board = comedi_board(dev);
 			break;
 		}
 		if (dev->board_ptr)
@@ -1213,11 +1223,13 @@ static int pci_dio_attach(struct comedi_device *dev,
 
 static void pci_dio_detach(struct comedi_device *dev)
 {
+	const struct dio_boardtype *this_board = comedi_board(dev);
+	struct pci_dio_private *devpriv = dev->private;
 	int i, j;
 	struct comedi_subdevice *s;
 	int subdev;
 
-	if (dev->private) {
+	if (devpriv) {
 		if (devpriv->valid)
 			pci_dio_reset(dev);
 		subdev = 0;
diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index f7d453f..ab65677 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -84,8 +84,6 @@ struct aio12_8_private {
 	unsigned int ao_readback[4];
 };
 
-#define devpriv	((struct aio12_8_private *) dev->private)
-
 static int aio_aio12_8_ai_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
@@ -125,6 +123,7 @@ static int aio_aio12_8_ao_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct aio12_8_private *devpriv = dev->private;
 	int i;
 	int val = devpriv->ao_readback[CR_CHAN(insn->chanspec)];
 
@@ -137,6 +136,7 @@ static int aio_aio12_8_ao_write(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct aio12_8_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 	unsigned long port = dev->iobase + AIO12_8_DAC_0 + (2 * chan);
@@ -166,6 +166,7 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
 	const struct aio12_8_boardtype *board = comedi_board(dev);
+	struct aio12_8_private *devpriv;
 	int iobase;
 	struct comedi_subdevice *s;
 	int ret;
@@ -180,8 +181,9 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 
 	dev->iobase = iobase;
 
-	if (alloc_private(dev, sizeof(struct aio12_8_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	ret = comedi_alloc_subdevices(dev, 3);
 	if (ret)
diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 16f28f6..ba1e3bb 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -57,14 +57,6 @@ static const struct aio_iiro_16_board aio_iiro_16_boards[] = {
 	 .do_ = 16},
 };
 
-struct aio_iiro_16_private {
-	int data;
-	struct pci_dev *pci_dev;
-	unsigned int ao_readback[2];
-};
-
-#define	devpriv	((struct aio_iiro_16_private *) dev->private)
-
 static int aio_iiro_16_dio_insn_bits_write(struct comedi_device *dev,
 					   struct comedi_subdevice *s,
 					   struct comedi_insn *insn,
@@ -116,9 +108,6 @@ static int aio_iiro_16_attach(struct comedi_device *dev,
 
 	dev->iobase = iobase;
 
-	if (alloc_private(dev, sizeof(struct aio_iiro_16_private)) < 0)
-		return -ENOMEM;
-
 	ret = comedi_alloc_subdevices(dev, 2);
 	if (ret)
 		return ret;
diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index 55f3050..1a71c0e 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -1360,15 +1360,17 @@ static int dio200_pci_common_attach(struct comedi_device *dev,
 static int dio200_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct dio200_board *thisboard = comedi_board(dev);
+	struct dio200_private *devpriv;
 	int ret;
 
 	dev_info(dev->class_dev, DIO200_DRIVER_NAME ": attach\n");
 
-	ret = alloc_private(dev, sizeof(struct dio200_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return ret;
 	}
+	devpriv = dev->private;
 
 	/* Process options and reserve resources according to bus type. */
 	if (IS_ENABLED(CONFIG_COMEDI_AMPLC_DIO200_ISA) &&
@@ -1408,6 +1410,7 @@ static int dio200_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static int __devinit dio200_attach_pci(struct comedi_device *dev,
 				       struct pci_dev *pci_dev)
 {
+	struct dio200_private *devpriv;
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_COMEDI_AMPLC_DIO200_PCI))
@@ -1415,11 +1418,14 @@ static int __devinit dio200_attach_pci(struct comedi_device *dev,
 
 	dev_info(dev->class_dev, DIO200_DRIVER_NAME ": attach pci %s\n",
 		 pci_name(pci_dev));
-	ret = alloc_private(dev, sizeof(struct dio200_private));
+
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return ret;
 	}
+	devpriv = dev->private;
+
 	dev->board_ptr = dio200_find_pci_board(pci_dev);
 	if (dev->board_ptr == NULL) {
 		dev_err(dev->class_dev, "BUG! cannot determine board type!\n");
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 77dae8e..aa5be99 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -517,14 +517,18 @@ static int pc236_pci_common_attach(struct comedi_device *dev,
 static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct pc236_board *thisboard = comedi_board(dev);
+	struct pc236_private *devpriv;
 	int ret;
 
 	dev_info(dev->class_dev, PC236_DRIVER_NAME ": attach\n");
-	ret = alloc_private(dev, sizeof(struct pc236_private));
+
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return ret;
 	}
+	devpriv = dev->private;
+
 	/* Process options according to bus type. */
 	if (IS_ENABLED(CONFIG_COMEDI_AMPLC_PC236_ISA) &&
 	    thisboard->bustype == isa_bustype) {
@@ -559,6 +563,7 @@ static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static int __devinit pc236_attach_pci(struct comedi_device *dev,
 				      struct pci_dev *pci_dev)
 {
+	struct pc236_private *devpriv = dev->private;
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_COMEDI_AMPLC_PC236_PCI))
@@ -566,11 +571,14 @@ static int __devinit pc236_attach_pci(struct comedi_device *dev,
 
 	dev_info(dev->class_dev, PC236_DRIVER_NAME ": attach pci %s\n",
 		 pci_name(pci_dev));
-	ret = alloc_private(dev, sizeof(struct pc236_private));
+
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return ret;
 	}
+	devpriv = dev->private;
+
 	dev->board_ptr = pc236_find_pci_board(pci_dev);
 	if (dev->board_ptr == NULL) {
 		dev_err(dev->class_dev, "BUG! cannot determine board type!\n");
diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index e90178d..0c29b70 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -270,6 +270,7 @@ static int pc263_pci_common_attach(struct comedi_device *dev,
 static int pc263_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct pc263_board *thisboard = comedi_board(dev);
+	struct pc263_private *devpriv;
 	int ret;
 
 	dev_info(dev->class_dev, PC263_DRIVER_NAME ": attach\n");
@@ -287,11 +288,13 @@ static int pc263_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		struct pci_dev *pci_dev;
 		int bus, slot;
 
-		ret = alloc_private(dev, sizeof(struct pc263_private));
+		ret = alloc_private(dev, sizeof(*devpriv));
 		if (ret < 0) {
 			dev_err(dev->class_dev, "error! out of memory!\n");
 			return ret;
 		}
+		devpriv = dev->private;
+
 		bus = it->options[0];
 		slot = it->options[1];
 		pci_dev = pc263_find_pci(dev, bus, slot);
@@ -312,6 +315,7 @@ static int pc263_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static int __devinit pc263_attach_pci(struct comedi_device *dev,
 				      struct pci_dev *pci_dev)
 {
+	struct pc263_private *devpriv;
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_COMEDI_AMPLC_PC263_PCI))
@@ -319,11 +323,14 @@ static int __devinit pc263_attach_pci(struct comedi_device *dev,
 
 	dev_info(dev->class_dev, PC263_DRIVER_NAME ": attach pci %s\n",
 		 pci_name(pci_dev));
-	ret = alloc_private(dev, sizeof(struct pc263_private));
+
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return ret;
 	}
+	devpriv = dev->private;
+
 	dev->board_ptr = pc263_find_pci_board(pci_dev);
 	if (dev->board_ptr == NULL) {
 		dev_err(dev->class_dev, "BUG! cannot determine board type!\n");
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index b87e10d..07e9e7d 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1473,6 +1473,7 @@ static int pci224_attach_common(struct comedi_device *dev,
 
 static int pci224_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	struct pci224_private *devpriv;
 	struct pci_dev *pci_dev;
 	int bus, slot;
 	int ret;
@@ -1481,11 +1482,13 @@ static int pci224_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	bus = it->options[0];
 	slot = it->options[1];
-	ret = alloc_private(dev, sizeof(struct pci224_private));
+
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return ret;
 	}
+	devpriv = dev->private;
 
 	pci_dev = pci224_find_pci(dev, bus, slot);
 	if (pci_dev == NULL)
@@ -1497,16 +1500,18 @@ static int pci224_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static int __devinit
 pci224_attach_pci(struct comedi_device *dev, struct pci_dev *pci_dev)
 {
+	struct pci224_private *devpriv;
 	int ret;
 
 	dev_info(dev->class_dev, DRIVER_NAME ": attach_pci %s\n",
 		 pci_name(pci_dev));
 
-	ret = alloc_private(dev, sizeof(struct pci224_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return ret;
 	}
+	devpriv = dev->private;
 
 	dev->board_ptr = pci224_find_pci_board(pci_dev);
 	if (dev->board_ptr == NULL) {
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 3d7f2cd..90e9f73 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2733,12 +2733,13 @@ static int pci230_alloc_private(struct comedi_device *dev)
 	int err;
 
 	/* sets dev->private to allocated memory */
-	err = alloc_private(dev, sizeof(struct pci230_private));
+	err = alloc_private(dev, sizeof(*devpriv));
 	if (err) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return err;
 	}
 	devpriv = dev->private;
+
 	spin_lock_init(&devpriv->isr_spinlock);
 	spin_lock_init(&devpriv->res_spinlock);
 	spin_lock_init(&devpriv->ai_stop_spinlock);
diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 58d4529..80b22b4 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -448,6 +448,7 @@ static int das16cs_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
 	const struct das16cs_board *thisboard;
+	struct das16cs_private *devpriv;
 	struct pcmcia_device *link;
 	struct comedi_subdevice *s;
 	int ret;
@@ -471,8 +472,9 @@ static int das16cs_attach(struct comedi_device *dev,
 		return ret;
 	dev->irq = link->irq;
 
-	if (alloc_private(dev, sizeof(struct das16cs_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	ret = comedi_alloc_subdevices(dev, 3);
 	if (ret)
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 39b02e8..a3dcaa3 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1548,7 +1548,7 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	int i;
 	int ret;
 
-	if (alloc_private(dev, sizeof(struct cb_pcidas_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
 	devpriv = dev->private;
 
diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index f5a7957..97d0c24 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -203,11 +203,6 @@ static const struct cb_pcidda_board cb_pcidda_boards[] = {
 };
 
 /*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct cb_pcidda_board *)dev->board_ptr)
-
-/*
  * this structure is for data unique to this hardware driver.  If
  * several hardware drivers keep similar information in this structure,
  * feel free to suggest moving the variable to the struct comedi_device
@@ -232,12 +227,6 @@ struct cb_pcidda_private {
 	u16 eeprom_data[EEPROM_SIZE];	/*  software copy of board's eeprom */
 };
 
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct cb_pcidda_private *)dev->private)
-
 /* static int cb_pcidda_ai_rinsn(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data); */
 static int cb_pcidda_ao_winsn(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
@@ -262,6 +251,8 @@ static void cb_pcidda_calibrate(struct comedi_device *dev, unsigned int channel,
 static int cb_pcidda_attach(struct comedi_device *dev,
 			    struct comedi_devconfig *it)
 {
+	const struct cb_pcidda_board *thisboard;
+	struct cb_pcidda_private *devpriv;
 	struct comedi_subdevice *s;
 	struct pci_dev *pcidev = NULL;
 	int index;
@@ -270,8 +261,9 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 /*
  * Allocate the private structure area.
  */
-	if (alloc_private(dev, sizeof(struct cb_pcidda_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 /*
  * Probe the device to determine what device in the series it is.
@@ -301,7 +293,8 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 found:
 	devpriv->pci_dev = pcidev;
 	dev->board_ptr = cb_pcidda_boards + index;
-	/*  "thisboard" macro can be used from here. */
+	thisboard = comedi_board(dev);
+
 	dev_dbg(dev->class_dev, "Found %s at requested position\n",
 		thisboard->name);
 
@@ -374,6 +367,8 @@ found:
 
 static void cb_pcidda_detach(struct comedi_device *dev)
 {
+	struct cb_pcidda_private *devpriv = dev->private;
+
 	if (devpriv) {
 		if (devpriv->pci_dev) {
 			if (devpriv->dac)
@@ -585,6 +580,7 @@ static int cb_pcidda_ao_winsn(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
+	struct cb_pcidda_private *devpriv = dev->private;
 	unsigned int command;
 	unsigned int channel, range;
 
@@ -634,6 +630,7 @@ static int cb_pcidda_ao_winsn(struct comedi_device *dev,
 /* lowlevel read from eeprom */
 static unsigned int cb_pcidda_serial_in(struct comedi_device *dev)
 {
+	struct cb_pcidda_private *devpriv = dev->private;
 	unsigned int value = 0;
 	int i;
 	const int value_width = 16;	/*  number of bits wide values are */
@@ -651,6 +648,7 @@ static unsigned int cb_pcidda_serial_in(struct comedi_device *dev)
 static void cb_pcidda_serial_out(struct comedi_device *dev, unsigned int value,
 				 unsigned int num_bits)
 {
+	struct cb_pcidda_private *devpriv = dev->private;
 	int i;
 
 	for (i = 1; i <= num_bits; i++) {
@@ -667,6 +665,7 @@ static void cb_pcidda_serial_out(struct comedi_device *dev, unsigned int value,
 static unsigned int cb_pcidda_read_eeprom(struct comedi_device *dev,
 					  unsigned int address)
 {
+	struct cb_pcidda_private *devpriv = dev->private;
 	unsigned int i;
 	unsigned int cal2_bits;
 	unsigned int value;
@@ -703,6 +702,7 @@ static void cb_pcidda_write_caldac(struct comedi_device *dev,
 				   unsigned int caldac, unsigned int channel,
 				   unsigned int value)
 {
+	struct cb_pcidda_private *devpriv = dev->private;
 	unsigned int cal2_bits;
 	unsigned int i;
 	/* caldacs use 3 bit channel specification */
@@ -797,6 +797,7 @@ static unsigned int eeprom_fine_byte(unsigned int word)
 static void cb_pcidda_calibrate(struct comedi_device *dev, unsigned int channel,
 				unsigned int range)
 {
+	struct cb_pcidda_private *devpriv = dev->private;
 	unsigned int coarse_offset, fine_offset, coarse_gain, fine_gain;
 
 	/* remember range so we can tell when we need to readjust calibration */
diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 1336fae..5c047e7 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -85,14 +85,10 @@ static const struct pcidio_board pcidio_boards[] = {
 	 },
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct pcidio_board *)dev->board_ptr)
-
 static struct pci_dev *pcidio_find_pci_dev(struct comedi_device *dev,
 					   struct comedi_devconfig *it)
 {
+	const struct pcidio_board *thisboard;
 	struct pci_dev *pcidev = NULL;
 	int bus = it->options[0];
 	int slot = it->options[1];
@@ -109,6 +105,7 @@ static struct pci_dev *pcidio_find_pci_dev(struct comedi_device *dev,
 		for (i = 0; i < ARRAY_SIZE(pcidio_boards); i++) {
 			if (pcidio_boards[i].dev_id == pcidev->device) {
 				dev->board_ptr = pcidio_boards + i;
+				thisboard = comedi_board(dev);
 				dev_dbg(dev->class_dev,
 					"Found %s on bus %i, slot %i\n",
 					thisboard->name, pcidev->bus->number,
@@ -125,12 +122,14 @@ static struct pci_dev *pcidio_find_pci_dev(struct comedi_device *dev,
 
 static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct pcidio_board *thisboard;
 	int i;
 	int ret;
 
 	dev->pcidev = pcidio_find_pci_dev(dev, it);
 	if (!dev->pcidev)
 		return -EIO;
+	thisboard = comedi_board(dev);
 
 	dev->board_name = thisboard->name;
 
@@ -156,6 +155,8 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void pcidio_detach(struct comedi_device *dev)
 {
+	const struct pcidio_board *thisboard = comedi_board(dev);
+
 	if (dev->pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(dev->pcidev);
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 2977f2d..7adc4fd 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -125,11 +125,6 @@ static const struct cb_pcimdas_board cb_pcimdas_boards[] = {
 #define N_BOARDS 1		/*  Max number of boards supported */
 
 /*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct cb_pcimdas_board *)dev->board_ptr)
-
-/*
  * this structure is for data unique to this hardware driver.  If
  * several hardware drivers keep similar information in this structure,
  * feel free to suggest moving the variable to the struct comedi_device
@@ -159,12 +154,6 @@ struct cb_pcimdas_private {
 
 };
 
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct cb_pcimdas_private *)dev->private)
-
 static int cb_pcimdas_ai_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data);
@@ -184,6 +173,8 @@ static int cb_pcimdas_ao_rinsn(struct comedi_device *dev,
 static int cb_pcimdas_attach(struct comedi_device *dev,
 			     struct comedi_devconfig *it)
 {
+	const struct cb_pcimdas_board *thisboard;
+	struct cb_pcimdas_private *devpriv;
 	struct comedi_subdevice *s;
 	struct pci_dev *pcidev = NULL;
 	int index;
@@ -193,8 +184,9 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 /*
  * Allocate the private structure area.
  */
-	if (alloc_private(dev, sizeof(struct cb_pcimdas_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 /*
  * Probe the device to determine what device in the series it is.
@@ -228,6 +220,7 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 	return -EIO;
 
 found:
+	thisboard = comedi_board(dev);
 
 	dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
 		cb_pcimdas_boards[index].name, pcidev->bus->number,
@@ -312,6 +305,8 @@ found:
 
 static void cb_pcimdas_detach(struct comedi_device *dev)
 {
+	struct cb_pcimdas_private *devpriv = dev->private;
+
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (devpriv) {
@@ -331,6 +326,8 @@ static int cb_pcimdas_ai_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	const struct cb_pcimdas_board *thisboard = comedi_board(dev);
+	struct cb_pcimdas_private *devpriv = dev->private;
 	int n, i;
 	unsigned int d;
 	unsigned int busy;
@@ -400,6 +397,7 @@ static int cb_pcimdas_ao_winsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct cb_pcimdas_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -429,6 +427,7 @@ static int cb_pcimdas_ao_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct cb_pcimdas_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index a801461..2a9a411 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -131,14 +131,6 @@ static const struct board_struct boards[] = {
 };
 
 /*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard    ((const struct board_struct *)dev->board_ptr)
-
-#define REG_SZ (thisboard->reg_sz)
-#define REGS_BADRINDEX (thisboard->regs_badrindex)
-
-/*
  * this structure is for data unique to this hardware driver.  If
  * several hardware drivers keep similar information in this structure,
  * feel free to suggest moving the variable to the struct comedi_device
@@ -157,12 +149,6 @@ struct board_private_struct {
 
 };
 
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct board_private_struct *)dev->private)
-
 static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data);
 static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -206,6 +192,8 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it);
  */
 static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct board_struct *thisboard;
+	struct board_private_struct *devpriv;
 	struct comedi_subdevice *s;
 	int err;
 
@@ -215,8 +203,9 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * if this function fails (returns negative) then the private area is
  * kfree'd by comedi
  */
-	if (alloc_private(dev, sizeof(struct board_private_struct)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 /*
  * If you can probe the device to determine what device in a series
@@ -226,6 +215,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	err = probe(dev, it);
 	if (err)
 		return err;
+	thisboard = comedi_board(dev);
 
 /* Output some info */
 	printk("comedi%d: %s: ", dev->minor, thisboard->name);
@@ -284,6 +274,8 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void detach(struct comedi_device *dev)
 {
+	struct board_private_struct *devpriv = dev->private;
+
 	if (devpriv) {
 		if (dev->subdevices && devpriv->attached_to_8255) {
 			subdev_8255_cleanup(dev, dev->subdevices + 2);
@@ -300,6 +292,7 @@ static void detach(struct comedi_device *dev)
 static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data)
 {
+	struct board_private_struct *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 	unsigned long offset = devpriv->registers + chan * 2;
@@ -339,6 +332,7 @@ static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data)
 {
+	struct board_private_struct *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -375,6 +369,8 @@ static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
  */
 static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 {
+	const struct board_struct *thisboard;
+	struct board_private_struct *devpriv = dev->private;
 	struct pci_dev *pcidev = NULL;
 	int index;
 	unsigned long registers;
@@ -399,6 +395,7 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 
 			devpriv->pci_dev = pcidev;
 			dev->board_ptr = boards + index;
+			thisboard = comedi_board(dev);
 			if (comedi_pci_enable(pcidev, thisboard->name)) {
 				printk
 				    ("cb_pcimdda: Failed to enable PCI device and request regions\n");
@@ -406,7 +403,7 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 			}
 			registers =
 			    pci_resource_start(devpriv->pci_dev,
-					       REGS_BADRINDEX);
+					       thisboard->regs_badrindex);
 			devpriv->registers = registers;
 			devpriv->dio_registers
 			    = devpriv->registers + thisboard->dio_offset;
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 5ed324c..3d04ad2 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -88,11 +88,6 @@ struct BondingBoard {
 	const char *name;
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct BondingBoard *)dev->board_ptr)
-
 struct BondedDevice {
 	struct comedi_device *dev;
 	unsigned minor;
@@ -116,12 +111,6 @@ struct Private {
 	unsigned nchans;
 };
 
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct Private *)dev->private)
-
 /* DIO devices are slightly special.  Although it is possible to
  * implement the insn_read/insn_write interface, it is much more
  * useful to applications if you implement the insn_bits interface.
@@ -131,6 +120,7 @@ static int bonding_dio_insn_bits(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct Private *devpriv = dev->private;
 #define LSAMPL_BITS (sizeof(unsigned int)*8)
 	unsigned nchans = LSAMPL_BITS, num_done = 0, i;
 
@@ -177,6 +167,7 @@ static int bonding_dio_insn_config(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn, unsigned int *data)
 {
+	struct Private *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec), ret, io_bits = s->io_bits;
 	unsigned int io;
 	struct BondedDevice *bdev;
@@ -230,6 +221,7 @@ static void *Realloc(const void *oldmem, size_t newlen, size_t oldlen)
 
 static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	struct Private *devpriv = dev->private;
 	int i;
 	struct comedi_device *devs_opened[COMEDI_NUM_BOARD_MINORS];
 
@@ -333,6 +325,8 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 static int bonding_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct BondingBoard *thisboard = comedi_board(dev);
+	struct Private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
 
@@ -342,8 +336,9 @@ static int bonding_attach(struct comedi_device *dev,
 	 * Allocate the private structure area.  alloc_private() is a
 	 * convenient macro defined in comedidev.h.
 	 */
-	if (alloc_private(dev, sizeof(struct Private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	/*
 	 * Setup our bonding from config params.. sets up our Private struct..
@@ -351,11 +346,7 @@ static int bonding_attach(struct comedi_device *dev,
 	if (!doDevConfig(dev, it))
 		return -EINVAL;
 
-	/*
-	 * Initialize dev->board_name.  Note that we can use the "thisboard"
-	 * macro now, since we just initialized it in the last line.
-	 */
-	dev->board_name = devpriv->name;
+	dev->board_name = thisboard->name;
 
 	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret)
@@ -380,6 +371,7 @@ static int bonding_attach(struct comedi_device *dev,
 
 static void bonding_detach(struct comedi_device *dev)
 {
+	struct Private *devpriv = dev->private;
 	unsigned long devs_closed = 0;
 
 	if (devpriv) {
diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index 9a63cac..fcad423 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -96,11 +96,12 @@ struct parport_private {
 	unsigned int c_data;
 	int enable_irq;
 };
-#define devpriv ((struct parport_private *)(dev->private))
 
 static int parport_insn_a(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	struct parport_private *devpriv = dev->private;
+
 	if (data[0]) {
 		devpriv->a_data &= ~data[0];
 		devpriv->a_data |= (data[0] & data[1]);
@@ -117,6 +118,8 @@ static int parport_insn_config_a(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct parport_private *devpriv = dev->private;
+
 	if (data[0]) {
 		s->io_bits = 0xff;
 		devpriv->c_data &= ~(1 << 5);
@@ -145,6 +148,8 @@ static int parport_insn_b(struct comedi_device *dev, struct comedi_subdevice *s,
 static int parport_insn_c(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	struct parport_private *devpriv = dev->private;
+
 	data[0] &= 0x0f;
 	if (data[0]) {
 		devpriv->c_data &= ~data[0];
@@ -245,6 +250,8 @@ static int parport_intr_cmdtest(struct comedi_device *dev,
 static int parport_intr_cmd(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	struct parport_private *devpriv = dev->private;
+
 	devpriv->c_data |= 0x10;
 	outb(devpriv->c_data, dev->iobase + PARPORT_C);
 
@@ -256,6 +263,8 @@ static int parport_intr_cmd(struct comedi_device *dev,
 static int parport_intr_cancel(struct comedi_device *dev,
 			       struct comedi_subdevice *s)
 {
+	struct parport_private *devpriv = dev->private;
+
 	printk(KERN_DEBUG "parport_intr_cancel()\n");
 
 	devpriv->c_data &= ~0x10;
@@ -269,6 +278,7 @@ static int parport_intr_cancel(struct comedi_device *dev,
 static irqreturn_t parport_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct parport_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 3;
 
 	if (!devpriv->enable_irq) {
@@ -286,6 +296,7 @@ static irqreturn_t parport_interrupt(int irq, void *d)
 static int parport_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	struct parport_private *devpriv;
 	int ret;
 	unsigned int irq;
 	unsigned long iobase;
@@ -316,9 +327,10 @@ static int parport_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	ret = alloc_private(dev, sizeof(struct parport_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	s = dev->subdevices + 0;
 	s->type = COMEDI_SUBD_DIO;
diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 523a809..71370d3 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -81,7 +81,6 @@ struct waveform_private {
 	unsigned timer_running:1;
 	unsigned int ao_loopbacks[N_CHANS];
 };
-#define devpriv ((struct waveform_private *)dev->private)
 
 /* 1000 nanosec in a microsec */
 static const int nano_per_micro = 1000;
@@ -98,6 +97,7 @@ static const struct comedi_lrange waveform_ai_ranges = {
 static short fake_sawtooth(struct comedi_device *dev, unsigned int range_index,
 			   unsigned long current_time)
 {
+	struct waveform_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
 	unsigned int offset = s->maxdata / 2;
 	u64 value;
@@ -122,6 +122,7 @@ static short fake_squarewave(struct comedi_device *dev,
 			     unsigned int range_index,
 			     unsigned long current_time)
 {
+	struct waveform_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
 	unsigned int offset = s->maxdata / 2;
 	u64 value;
@@ -175,6 +176,7 @@ static short fake_waveform(struct comedi_device *dev, unsigned int channel,
 static void waveform_ai_interrupt(unsigned long arg)
 {
 	struct comedi_device *dev = (struct comedi_device *)arg;
+	struct waveform_private *devpriv = dev->private;
 	struct comedi_async *async = dev->read_subdev->async;
 	struct comedi_cmd *cmd = &async->cmd;
 	unsigned int i, j;
@@ -362,6 +364,7 @@ static int waveform_ai_cmdtest(struct comedi_device *dev,
 static int waveform_ai_cmd(struct comedi_device *dev,
 			   struct comedi_subdevice *s)
 {
+	struct waveform_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
 	if (cmd->flags & TRIG_RT) {
@@ -395,6 +398,8 @@ static int waveform_ai_cmd(struct comedi_device *dev,
 static int waveform_ai_cancel(struct comedi_device *dev,
 			      struct comedi_subdevice *s)
 {
+	struct waveform_private *devpriv = dev->private;
+
 	devpriv->timer_running = 0;
 	del_timer(&devpriv->timer);
 	return 0;
@@ -404,6 +409,7 @@ static int waveform_ai_insn_read(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct waveform_private *devpriv = dev->private;
 	int i, chan = CR_CHAN(insn->chanspec);
 
 	for (i = 0; i < insn->n; i++)
@@ -416,6 +422,7 @@ static int waveform_ao_insn_write(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct waveform_private *devpriv = dev->private;
 	int i, chan = CR_CHAN(insn->chanspec);
 
 	for (i = 0; i < insn->n; i++)
@@ -428,6 +435,7 @@ static int waveform_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
 	const struct waveform_board *board = comedi_board(dev);
+	struct waveform_private *devpriv;
 	struct comedi_subdevice *s;
 	int amplitude = it->options[0];
 	int period = it->options[1];
@@ -436,8 +444,9 @@ static int waveform_attach(struct comedi_device *dev,
 
 	dev->board_name = board->name;
 
-	if (alloc_private(dev, sizeof(struct waveform_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	/* set default amplitude and period */
 	if (amplitude <= 0)
@@ -496,7 +505,9 @@ static int waveform_attach(struct comedi_device *dev,
 
 static void waveform_detach(struct comedi_device *dev)
 {
-	if (dev->private)
+	struct waveform_private *devpriv = dev->private;
+
+	if (devpriv)
 		waveform_ai_cancel(dev, dev->read_subdev);
 }
 
diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 52b597b..d56a890 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -55,12 +55,11 @@ static const struct contec_board contec_boards[] = {
 
 #define PCI_DEVICE_ID_PIO1616L 0x8172
 
-#define thisboard ((const struct contec_board *)dev->board_ptr)
-
 static int contec_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	const struct contec_board *thisboard = comedi_board(dev);
 
 	dev_dbg(dev->class_dev, "contec_do_insn_bits called\n");
 	dev_dbg(dev->class_dev, "data: %d %d\n", data[0], data[1]);
@@ -79,6 +78,7 @@ static int contec_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	const struct contec_board *thisboard = comedi_board(dev);
 
 	dev_dbg(dev->class_dev, "contec_di_insn_bits called\n");
 	dev_dbg(dev->class_dev, "data: %d %d\n", data[0], data[1]);
@@ -113,6 +113,7 @@ static struct pci_dev *contec_find_pci_dev(struct comedi_device *dev,
 
 static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct contec_board *thisboard;
 	struct comedi_subdevice *s;
 	int ret;
 
@@ -125,6 +126,7 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->pcidev = contec_find_pci_dev(dev, it);
 	if (!dev->pcidev)
 		return -EIO;
+	thisboard = comedi_board(dev);
 
 	dev->board_name = thisboard->name;
 
diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 8455cb9..6ede0c6 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -309,8 +309,6 @@ static const struct daq200_boardtype boardtypes[] = {
 	{"ids4", DAQBOARD2000_SUBSYSTEM_IDS4},
 };
 
-#define this_board ((const struct daq200_boardtype *)dev->board_ptr)
-
 struct daqboard2000_private {
 	enum {
 		card_daqboard_2000
@@ -322,10 +320,9 @@ struct daqboard2000_private {
 	unsigned int ao_readback[2];
 };
 
-#define devpriv ((struct daqboard2000_private *)dev->private)
-
 static void writeAcqScanListEntry(struct comedi_device *dev, u16 entry)
 {
+	struct daqboard2000_private *devpriv = dev->private;
 	struct daqboard2000_hw *fpga = devpriv->daq;
 
 /* udelay(4); */
@@ -384,6 +381,7 @@ static int daqboard2000_ai_insn_read(struct comedi_device *dev,
 				     struct comedi_insn *insn,
 				     unsigned int *data)
 {
+	struct daqboard2000_private *devpriv = dev->private;
 	int i;
 	struct daqboard2000_hw *fpga = devpriv->daq;
 	int gain, chan, timeout;
@@ -442,6 +440,7 @@ static int daqboard2000_ao_insn_read(struct comedi_device *dev,
 				     struct comedi_insn *insn,
 				     unsigned int *data)
 {
+	struct daqboard2000_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -456,6 +455,7 @@ static int daqboard2000_ao_insn_write(struct comedi_device *dev,
 				      struct comedi_insn *insn,
 				      unsigned int *data)
 {
+	struct daqboard2000_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 	struct daqboard2000_hw *fpga = devpriv->daq;
@@ -485,6 +485,8 @@ static int daqboard2000_ao_insn_write(struct comedi_device *dev,
 
 static void daqboard2000_resetLocalBus(struct comedi_device *dev)
 {
+	struct daqboard2000_private *devpriv = dev->private;
+
 	dev_dbg(dev->class_dev, "daqboard2000_resetLocalBus\n");
 	writel(DAQBOARD2000_SECRLocalBusHi, devpriv->plx + 0x6c);
 	udelay(10000);
@@ -494,6 +496,8 @@ static void daqboard2000_resetLocalBus(struct comedi_device *dev)
 
 static void daqboard2000_reloadPLX(struct comedi_device *dev)
 {
+	struct daqboard2000_private *devpriv = dev->private;
+
 	dev_dbg(dev->class_dev, "daqboard2000_reloadPLX\n");
 	writel(DAQBOARD2000_SECRReloadLo, devpriv->plx + 0x6c);
 	udelay(10000);
@@ -505,6 +509,8 @@ static void daqboard2000_reloadPLX(struct comedi_device *dev)
 
 static void daqboard2000_pulseProgPin(struct comedi_device *dev)
 {
+	struct daqboard2000_private *devpriv = dev->private;
+
 	dev_dbg(dev->class_dev, "daqboard2000_pulseProgPin 1\n");
 	writel(DAQBOARD2000_SECRProgPinHi, devpriv->plx + 0x6c);
 	udelay(10000);
@@ -514,6 +520,7 @@ static void daqboard2000_pulseProgPin(struct comedi_device *dev)
 
 static int daqboard2000_pollCPLD(struct comedi_device *dev, int mask)
 {
+	struct daqboard2000_private *devpriv = dev->private;
 	int result = 0;
 	int i;
 	int cpld;
@@ -533,6 +540,7 @@ static int daqboard2000_pollCPLD(struct comedi_device *dev, int mask)
 
 static int daqboard2000_writeCPLD(struct comedi_device *dev, int data)
 {
+	struct daqboard2000_private *devpriv = dev->private;
 	int result = 0;
 
 	udelay(10);
@@ -547,6 +555,7 @@ static int daqboard2000_writeCPLD(struct comedi_device *dev, int data)
 static int initialize_daqboard2000(struct comedi_device *dev,
 				   unsigned char *cpld_array, int len)
 {
+	struct daqboard2000_private *devpriv = dev->private;
 	int result = -EIO;
 	/* Read the serial EEPROM control register */
 	int secr;
@@ -608,6 +617,7 @@ static void daqboard2000_adcStopDmaTransfer(struct comedi_device *dev)
 
 static void daqboard2000_adcDisarm(struct comedi_device *dev)
 {
+	struct daqboard2000_private *devpriv = dev->private;
 	struct daqboard2000_hw *fpga = devpriv->daq;
 
 	/* Disable hardware triggers */
@@ -630,6 +640,7 @@ static void daqboard2000_adcDisarm(struct comedi_device *dev)
 
 static void daqboard2000_activateReferenceDacs(struct comedi_device *dev)
 {
+	struct daqboard2000_private *devpriv = dev->private;
 	struct daqboard2000_hw *fpga = devpriv->daq;
 	int timeout;
 
@@ -706,6 +717,8 @@ static int daqboard2000_8255_cb(int dir, int port, int data,
 static int daqboard2000_attach(struct comedi_device *dev,
 			       struct comedi_devconfig *it)
 {
+	const struct daq200_boardtype *this_board;
+	struct daqboard2000_private *devpriv;
 	int result = 0;
 	struct comedi_subdevice *s;
 	struct pci_dev *card = NULL;
@@ -716,9 +729,10 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	bus = it->options[0];
 	slot = it->options[1];
 
-	result = alloc_private(dev, sizeof(struct daqboard2000_private));
+	result = alloc_private(dev, sizeof(*devpriv));
 	if (result < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	for (card = pci_get_device(0x1616, 0x0409, NULL);
 	     card != NULL; card = pci_get_device(0x1616, 0x0409, card)) {
@@ -759,6 +773,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 			dev->board_ptr = boardtypes;
 		}
 	}
+	this_board = comedi_board(dev);
 
 	result = comedi_pci_enable(card, "daqboard2000");
 	if (result < 0) {
@@ -840,6 +855,8 @@ out:
 
 static void daqboard2000_detach(struct comedi_device *dev)
 {
+	struct daqboard2000_private *devpriv = dev->private;
+
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 	if (dev->irq)
diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index 874e02e..c6a1b9a 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -909,13 +909,17 @@ das08_find_pci_board(struct pci_dev *pdev)
 static int __devinit __maybe_unused
 das08_attach_pci(struct comedi_device *dev, struct pci_dev *pdev)
 {
+	struct das08_private_struct *devpriv;
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_COMEDI_DAS08_PCI))
 		return -EINVAL;
-	ret = alloc_private(dev, sizeof(struct das08_private_struct));
+
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
+
 	dev_info(dev->class_dev, "attach pci %s\n", pci_name(pdev));
 	dev->board_ptr = das08_find_pci_board(pdev);
 	if (dev->board_ptr == NULL) {
@@ -984,7 +988,7 @@ das08_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int ret;
 	unsigned long iobase;
 
-	ret = alloc_private(dev, sizeof(struct das08_private_struct));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
 	devpriv = dev->private;
diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index f5700de..dcff2c7 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -64,13 +64,15 @@ static int das08_cs_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
 	const struct das08_board_struct *thisboard = comedi_board(dev);
+	struct das08_private_struct *devpriv;
 	int ret;
 	unsigned long iobase;
 	struct pcmcia_device *link = cur_dev;	/*  XXX hack */
 
-	ret = alloc_private(dev, sizeof(struct das08_private_struct));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	dev_info(dev->class_dev, "das08_cs: attach\n");
 	/*  deal with a pci board */
diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 895cc77..f79b678 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -392,12 +392,12 @@ struct das16_private_struct {
 	volatile short timer_running;
 	volatile short timer_mode;	/*  true if using timer mode */
 };
-#define devpriv ((struct das16_private_struct *)(dev->private))
 
 static int das16_cmd_test(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_cmd *cmd)
 {
 	const struct das16_board *board = comedi_board(dev);
+	struct das16_private_struct *devpriv = dev->private;
 	int err = 0, tmp;
 	int gain, start_chan, i;
 	int mask;
@@ -560,6 +560,7 @@ static int das16_cmd_test(struct comedi_device *dev, struct comedi_subdevice *s,
 static unsigned int das16_suggest_transfer_size(struct comedi_device *dev,
 						struct comedi_cmd cmd)
 {
+	struct das16_private_struct *devpriv = dev->private;
 	unsigned int size;
 	unsigned int freq;
 
@@ -601,6 +602,8 @@ static unsigned int das16_suggest_transfer_size(struct comedi_device *dev,
 static unsigned int das16_set_pacer(struct comedi_device *dev, unsigned int ns,
 				    int rounding_flags)
 {
+	struct das16_private_struct *devpriv = dev->private;
+
 	i8253_cascade_ns_to_timer_2div(devpriv->clockbase, &(devpriv->divisor1),
 				       &(devpriv->divisor2), &ns,
 				       rounding_flags & TRIG_ROUND_MASK);
@@ -615,6 +618,7 @@ static unsigned int das16_set_pacer(struct comedi_device *dev, unsigned int ns,
 static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	const struct das16_board *board = comedi_board(dev);
+	struct das16_private_struct *devpriv = dev->private;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
 	unsigned int byte;
@@ -721,6 +725,7 @@ static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 static int das16_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	const struct das16_board *board = comedi_board(dev);
+	struct das16_private_struct *devpriv = dev->private;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->spinlock, flags);
@@ -758,6 +763,7 @@ static int das16_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
 	const struct das16_board *board = comedi_board(dev);
+	struct das16_private_struct *devpriv = dev->private;
 	int i, n;
 	int range;
 	int chan;
@@ -868,10 +874,12 @@ static int das16_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 */
 static int disable_dma_on_even(struct comedi_device *dev)
 {
+	struct das16_private_struct *devpriv = dev->private;
 	int residue;
 	int i;
 	static const int disable_limit = 100;
 	static const int enable_timeout = 100;
+
 	disable_dma(devpriv->dma_chan);
 	residue = get_dma_residue(devpriv->dma_chan);
 	for (i = 0; i < disable_limit && (residue % 2); ++i) {
@@ -897,6 +905,7 @@ static int disable_dma_on_even(struct comedi_device *dev)
 static void das16_interrupt(struct comedi_device *dev)
 {
 	const struct das16_board *board = comedi_board(dev);
+	struct das16_private_struct *devpriv = dev->private;
 	unsigned long dma_flags, spin_flags;
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct comedi_async *async;
@@ -993,6 +1002,7 @@ static irqreturn_t das16_dma_interrupt(int irq, void *d)
 static void das16_timer_interrupt(unsigned long arg)
 {
 	struct comedi_device *dev = (struct comedi_device *)arg;
+	struct das16_private_struct *devpriv = dev->private;
 
 	das16_interrupt(dev);
 
@@ -1021,6 +1031,7 @@ static void reg_dump(struct comedi_device *dev)
 static int das16_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct das16_board *board = comedi_board(dev);
+	struct das16_private_struct *devpriv = dev->private;
 	int status;
 	int diobits;
 
@@ -1055,6 +1066,7 @@ static int das16_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int das1600_mode_detect(struct comedi_device *dev)
 {
+	struct das16_private_struct *devpriv = dev->private;
 	int status = 0;
 
 	status = inb(dev->iobase + DAS1600_STATUS_B);
@@ -1100,6 +1112,7 @@ static void das16_ai_munge(struct comedi_device *dev,
 static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct das16_board *board = comedi_board(dev);
+	struct das16_private_struct *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
 	unsigned int irq;
@@ -1134,9 +1147,10 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 	}
 
-	ret = alloc_private(dev, sizeof(struct das16_private_struct));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	if (board->size < 0x400) {
 		printk(" 0x%04lx-0x%04lx\n", iobase, iobase + board->size);
@@ -1373,6 +1387,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static void das16_detach(struct comedi_device *dev)
 {
 	const struct das16_board *board = comedi_board(dev);
+	struct das16_private_struct *devpriv = dev->private;
 
 	das16_reset(dev);
 	if (dev->subdevices)
diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index 2009263..102c8ce 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -149,7 +149,6 @@ struct das16m1_private_struct {
 	unsigned int divisor1;	/*  divides master clock to obtain conversion speed */
 	unsigned int divisor2;	/*  divides master clock to obtain conversion speed */
 };
-#define devpriv ((struct das16m1_private_struct *)(dev->private))
 
 static inline short munge_sample(short data)
 {
@@ -168,6 +167,7 @@ static int das16m1_cmd_test(struct comedi_device *dev,
 			    struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
 	const struct das16m1_board *board = comedi_board(dev);
+	struct das16m1_private_struct *devpriv = dev->private;
 	unsigned int err = 0, tmp, i;
 
 	/* make sure triggers are valid */
@@ -295,6 +295,8 @@ static int das16m1_cmd_test(struct comedi_device *dev,
 static unsigned int das16m1_set_pacer(struct comedi_device *dev,
 				      unsigned int ns, int rounding_flags)
 {
+	struct das16m1_private_struct *devpriv = dev->private;
+
 	i8253_cascade_ns_to_timer_2div(DAS16M1_XTAL, &(devpriv->divisor1),
 				       &(devpriv->divisor2), &ns,
 				       rounding_flags & TRIG_ROUND_MASK);
@@ -311,6 +313,7 @@ static unsigned int das16m1_set_pacer(struct comedi_device *dev,
 static int das16m1_cmd_exec(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	struct das16m1_private_struct *devpriv = dev->private;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
 	unsigned int byte, i;
@@ -374,6 +377,8 @@ static int das16m1_cmd_exec(struct comedi_device *dev,
 
 static int das16m1_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct das16m1_private_struct *devpriv = dev->private;
+
 	devpriv->control_state &= ~INTE & ~PACER_MASK;
 	outb(devpriv->control_state, dev->iobase + DAS16M1_INTR_CONTROL);
 
@@ -384,6 +389,7 @@ static int das16m1_ai_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct das16m1_private_struct *devpriv = dev->private;
 	int i, n;
 	int byte;
 	const int timeout = 1000;
@@ -435,6 +441,7 @@ static int das16m1_do_wbits(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct das16m1_private_struct *devpriv = dev->private;
 	unsigned int wbits;
 
 	/*  only set bits that have been masked */
@@ -454,6 +461,7 @@ static int das16m1_do_wbits(struct comedi_device *dev,
 
 static void das16m1_handler(struct comedi_device *dev, unsigned int status)
 {
+	struct das16m1_private_struct *devpriv = dev->private;
 	struct comedi_subdevice *s;
 	struct comedi_async *async;
 	struct comedi_cmd *cmd;
@@ -601,6 +609,7 @@ static int das16m1_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
 	const struct das16m1_board *board = comedi_board(dev);
+	struct das16m1_private_struct *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
 	unsigned int irq;
@@ -608,9 +617,10 @@ static int das16m1_attach(struct comedi_device *dev,
 
 	iobase = it->options[0];
 
-	ret = alloc_private(dev, sizeof(struct das16m1_private_struct));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	dev->board_name = board->name;
 
diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 25e7e56..5ef4063 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -429,11 +429,6 @@ static const struct das1800_board das1800_boards[] = {
 	 },
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct das1800_board *)dev->board_ptr)
-
 struct das1800_private {
 	volatile unsigned int count;	/* number of data points left to be taken */
 	unsigned int divisor1;	/* value to load into board's counter 1 for timed conversions */
@@ -454,8 +449,6 @@ struct das1800_private {
 	short ao_update_bits;	/* remembers the last write to the 'update' dac */
 };
 
-#define devpriv ((struct das1800_private *)dev->private)
-
 /* analog out range for boards with basic analog out */
 static const struct comedi_lrange range_ao_1 = {
 	1,
@@ -475,9 +468,11 @@ static const struct comedi_lrange range_ao_2 = {
 };
 */
 
-static inline uint16_t munge_bipolar_sample(const struct comedi_device *dev,
+static inline uint16_t munge_bipolar_sample(struct comedi_device *dev,
 					    uint16_t sample)
 {
+	const struct das1800_board *thisboard = comedi_board(dev);
+
 	sample += 1 << (thisboard->resolution - 1);
 	return sample;
 }
@@ -501,6 +496,7 @@ static void munge_data(struct comedi_device *dev, uint16_t * array,
 static void das1800_handle_fifo_half_full(struct comedi_device *dev,
 					  struct comedi_subdevice *s)
 {
+	struct das1800_private *devpriv = dev->private;
 	int numPoints = 0;	/* number of points to read */
 	struct comedi_cmd *cmd = &s->async->cmd;
 
@@ -520,6 +516,7 @@ static void das1800_handle_fifo_half_full(struct comedi_device *dev,
 static void das1800_handle_fifo_not_empty(struct comedi_device *dev,
 					  struct comedi_subdevice *s)
 {
+	struct das1800_private *devpriv = dev->private;
 	short dpnt;
 	int unipolar;
 	struct comedi_cmd *cmd = &s->async->cmd;
@@ -548,6 +545,7 @@ static void das1800_flush_dma_channel(struct comedi_device *dev,
 				      struct comedi_subdevice *s,
 				      unsigned int channel, uint16_t *buffer)
 {
+	struct das1800_private *devpriv = dev->private;
 	unsigned int num_bytes, num_samples;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
@@ -578,6 +576,7 @@ static void das1800_flush_dma_channel(struct comedi_device *dev,
 static void das1800_flush_dma(struct comedi_device *dev,
 			      struct comedi_subdevice *s)
 {
+	struct das1800_private *devpriv = dev->private;
 	unsigned long flags;
 	const int dual_dma = devpriv->irq_dma_bits & DMA_DUAL;
 
@@ -609,6 +608,7 @@ static void das1800_flush_dma(struct comedi_device *dev,
 static void das1800_handle_dma(struct comedi_device *dev,
 			       struct comedi_subdevice *s, unsigned int status)
 {
+	struct das1800_private *devpriv = dev->private;
 	unsigned long flags;
 	const int dual_dma = devpriv->irq_dma_bits & DMA_DUAL;
 
@@ -643,6 +643,8 @@ static void das1800_handle_dma(struct comedi_device *dev,
 
 static int das1800_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct das1800_private *devpriv = dev->private;
+
 	outb(0x0, dev->iobase + DAS1800_STATUS);	/* disable conversions */
 	outb(0x0, dev->iobase + DAS1800_CONTROL_B);	/* disable interrupts and dma */
 	outb(0x0, dev->iobase + DAS1800_CONTROL_A);	/* disable and clear fifo and stop triggering */
@@ -656,6 +658,7 @@ static int das1800_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 /* the guts of the interrupt handler, that is shared with das1800_ai_poll */
 static void das1800_ai_handler(struct comedi_device *dev)
 {
+	struct das1800_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;	/* analog input subdevice */
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
@@ -783,6 +786,8 @@ static int das1800_ai_do_cmdtest(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_cmd *cmd)
 {
+	const struct das1800_board *thisboard = comedi_board(dev);
+	struct das1800_private *devpriv = dev->private;
 	int err = 0;
 	int tmp;
 	unsigned int tmp_arg;
@@ -1030,6 +1035,7 @@ static int control_c_bits(struct comedi_cmd cmd)
 /* loads counters with divisor1, divisor2 from private structure */
 static int das1800_set_frequency(struct comedi_device *dev)
 {
+	struct das1800_private *devpriv = dev->private;
 	int err = 0;
 
 	/*  counter 1, mode 2 */
@@ -1049,6 +1055,8 @@ static int das1800_set_frequency(struct comedi_device *dev)
 /* sets up counters */
 static int setup_counters(struct comedi_device *dev, struct comedi_cmd cmd)
 {
+	struct das1800_private *devpriv = dev->private;
+
 	/*  setup cascaded counters for conversion/scan frequency */
 	switch (cmd.scan_begin_src) {
 	case TRIG_FOLLOW:	/*  not in burst mode */
@@ -1127,6 +1135,7 @@ static unsigned int suggest_transfer_size(struct comedi_cmd *cmd)
 /* sets up dma */
 static void setup_dma(struct comedi_device *dev, struct comedi_cmd cmd)
 {
+	struct das1800_private *devpriv = dev->private;
 	unsigned long lock_flags;
 	const int dual_dma = devpriv->irq_dma_bits & DMA_DUAL;
 
@@ -1193,6 +1202,7 @@ static void program_chanlist(struct comedi_device *dev, struct comedi_cmd cmd)
 static int das1800_ai_do_cmd(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
+	struct das1800_private *devpriv = dev->private;
 	int ret;
 	int control_a, control_c;
 	struct comedi_async *async = s->async;
@@ -1256,6 +1266,7 @@ static int das1800_ai_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	const struct das1800_board *thisboard = comedi_board(dev);
 	int i, n;
 	int chan, range, aref, chan_range;
 	int timeout = 1000;
@@ -1319,6 +1330,8 @@ static int das1800_ao_winsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	const struct das1800_board *thisboard = comedi_board(dev);
+	struct das1800_private *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 /* int range = CR_RANGE(insn->chanspec); */
 	int update_chan = thisboard->ao_n_chan - 1;
@@ -1361,6 +1374,7 @@ static int das1800_do_wbits(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct das1800_private *devpriv = dev->private;
 	unsigned int wbits;
 
 	/*  only set bits that have been masked */
@@ -1380,6 +1394,7 @@ static int das1800_do_wbits(struct comedi_device *dev,
 static int das1800_init_dma(struct comedi_device *dev, unsigned int dma0,
 			    unsigned int dma1)
 {
+	struct das1800_private *devpriv = dev->private;
 	unsigned long flags;
 
 	/*  need an irq to do dma */
@@ -1537,6 +1552,8 @@ static int das1800_probe(struct comedi_device *dev)
 static int das1800_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct das1800_board *thisboard;
+	struct das1800_private *devpriv;
 	struct comedi_subdevice *s;
 	unsigned long iobase = it->options[0];
 	unsigned int irq = it->options[1];
@@ -1547,8 +1564,9 @@ static int das1800_attach(struct comedi_device *dev,
 	int retval;
 
 	/* allocate and initialize dev->private */
-	if (alloc_private(dev, sizeof(struct das1800_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	printk(KERN_DEBUG "comedi%d: %s: io 0x%lx", dev->minor,
 	       dev->driver->driver_name, iobase);
@@ -1583,6 +1601,7 @@ static int das1800_attach(struct comedi_device *dev,
 	}
 
 	dev->board_ptr = das1800_boards + board;
+	thisboard = comedi_board(dev);
 	dev->board_name = thisboard->name;
 
 	/*  if it is an 'ao' board with fancy analog out then we need extra io ports */
@@ -1718,11 +1737,13 @@ static int das1800_attach(struct comedi_device *dev,
 
 static void das1800_detach(struct comedi_device *dev)
 {
+	struct das1800_private *devpriv = dev->private;
+
 	if (dev->iobase)
 		release_region(dev->iobase, DAS1800_SIZE);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-	if (dev->private) {
+	if (devpriv) {
 		if (devpriv->iobase2)
 			release_region(devpriv->iobase2, DAS1800_SIZE);
 		if (devpriv->dma0)
diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index e3afcfa..a2e0cb8 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -104,7 +104,6 @@ struct das6402_private {
 
 	int das6402_ignoreirq;
 };
-#define devpriv ((struct das6402_private *)dev->private)
 
 static void das6402_ai_fifo_dregs(struct comedi_device *dev,
 				  struct comedi_subdevice *s)
@@ -152,6 +151,7 @@ static void das6402_setcounter(struct comedi_device *dev)
 static irqreturn_t intr_handler(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct das6402_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices;
 
 	if (!dev->attached || devpriv->das6402_ignoreirq) {
@@ -196,6 +196,8 @@ static void das6402_ai_fifo_read(struct comedi_device *dev, short *data, int n)
 static int das6402_ai_cancel(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
+	struct das6402_private *devpriv = dev->private;
+
 	/*
 	 *  This function should reset the board from whatever condition it
 	 *  is in (i.e., acquiring data), to a non-active state.
@@ -217,6 +219,8 @@ static int das6402_ai_cancel(struct comedi_device *dev,
 static int das6402_ai_mode2(struct comedi_device *dev,
 			    struct comedi_subdevice *s, comedi_trig * it)
 {
+	struct das6402_private *devpriv = dev->private;
+
 	devpriv->das6402_ignoreirq = 1;
 	dev_dbg(dev->class_dev, "Starting acquisition\n");
 	outb_p(0x03, dev->iobase + 10);	/* enable external trigging */
@@ -236,6 +240,7 @@ static int das6402_ai_mode2(struct comedi_device *dev,
 
 static int board_init(struct comedi_device *dev)
 {
+	struct das6402_private *devpriv = dev->private;
 	BYTE b;
 
 	devpriv->das6402_ignoreirq = 1;
@@ -277,6 +282,7 @@ static int board_init(struct comedi_device *dev)
 static int das6402_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	struct das6402_private *devpriv;
 	unsigned int irq;
 	unsigned long iobase;
 	int ret;
@@ -303,9 +309,10 @@ static int das6402_attach(struct comedi_device *dev,
 		return ret;
 
 	dev->irq = irq;
-	ret = alloc_private(dev, sizeof(struct das6402_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret)
diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index a0959a5..cc777c2 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -228,11 +228,6 @@ static const struct das800_board das800_boards[] = {
 	 },
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct das800_board *)dev->board_ptr)
-
 struct das800_private {
 	volatile unsigned int count;	/* number of data points left to be taken */
 	volatile int forever;	/* flag indicating whether we should take data forever */
@@ -241,8 +236,6 @@ struct das800_private {
 	volatile int do_bits;	/* digital output bits */
 };
 
-#define devpriv ((struct das800_private *)dev->private)
-
 static int das800_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it);
 static void das800_detach(struct comedi_device *dev);
@@ -281,6 +274,7 @@ static int das800_set_frequency(struct comedi_device *dev);
 /* checks and probes das-800 series board type */
 static int das800_probe(struct comedi_device *dev)
 {
+	const struct das800_board *thisboard = comedi_board(dev);
 	int id_bits;
 	unsigned long irq_flags;
 	int board;
@@ -367,6 +361,8 @@ static irqreturn_t das800_interrupt(int irq, void *d)
 	short i;		/* loop index */
 	short dataPoint = 0;
 	struct comedi_device *dev = d;
+	const struct das800_board *thisboard = comedi_board(dev);
+	struct das800_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;	/* analog input subdevice */
 	struct comedi_async *async;
 	int status;
@@ -461,6 +457,8 @@ static irqreturn_t das800_interrupt(int irq, void *d)
 
 static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct das800_board *thisboard;
+	struct das800_private *devpriv;
 	struct comedi_subdevice *s;
 	unsigned long iobase = it->options[0];
 	unsigned int irq = it->options[1];
@@ -473,8 +471,9 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		dev_dbg(dev->class_dev, "irq %u\n", irq);
 
 	/* allocate and initialize dev->private */
-	if (alloc_private(dev, sizeof(struct das800_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	if (iobase == 0) {
 		dev_err(dev->class_dev,
@@ -495,6 +494,7 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -ENODEV;
 	}
 	dev->board_ptr = das800_boards + board;
+	thisboard = comedi_board(dev);
 
 	/* grab our IRQ */
 	if (irq == 1 || irq > 7) {
@@ -569,6 +569,8 @@ static void das800_detach(struct comedi_device *dev)
 
 static int das800_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct das800_private *devpriv = dev->private;
+
 	devpriv->forever = 0;
 	devpriv->count = 0;
 	disable_das800(dev);
@@ -578,7 +580,10 @@ static int das800_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 /* enable_das800 makes the card start taking hardware triggered conversions */
 static void enable_das800(struct comedi_device *dev)
 {
+	const struct das800_board *thisboard = comedi_board(dev);
+	struct das800_private *devpriv = dev->private;
 	unsigned long irq_flags;
+
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
 	/*  enable fifo-half full interrupts for cio-das802/16 */
 	if (thisboard->resolution == 16)
@@ -604,6 +609,8 @@ static int das800_ai_do_cmdtest(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_cmd *cmd)
 {
+	const struct das800_board *thisboard = comedi_board(dev);
+	struct das800_private *devpriv = dev->private;
 	int err = 0;
 	int tmp;
 	int gain, startChan;
@@ -730,6 +737,8 @@ static int das800_ai_do_cmdtest(struct comedi_device *dev,
 static int das800_ai_do_cmd(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	const struct das800_board *thisboard = comedi_board(dev);
+	struct das800_private *devpriv = dev->private;
 	int startChan, endChan, scan, gain;
 	int conv_bits;
 	unsigned long irq_flags;
@@ -813,6 +822,8 @@ static int das800_ai_rinsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
 {
+	const struct das800_board *thisboard = comedi_board(dev);
+	struct das800_private *devpriv = dev->private;
 	int i, n;
 	int chan;
 	int range;
@@ -882,6 +893,7 @@ static int das800_do_wbits(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
 {
+	struct das800_private *devpriv = dev->private;
 	int wbits;
 	unsigned long irq_flags;
 
@@ -905,6 +917,7 @@ static int das800_do_wbits(struct comedi_device *dev,
 /* loads counters with divisor1, divisor2 from private structure */
 static int das800_set_frequency(struct comedi_device *dev)
 {
+	struct das800_private *devpriv = dev->private;
 	int err = 0;
 
 	if (i8254_load(dev->iobase + DAS800_8254, 0, 1, devpriv->divisor1, 2))
diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index d332269..8adaa06 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -225,16 +225,12 @@ static const struct dt2801_board boardtypes[] = {
 	 .dabits = 12},
 };
 
-#define boardtype (*(const struct dt2801_board *)dev->board_ptr)
-
 struct dt2801_private {
 
 	const struct comedi_lrange *dac_range_types[2];
 	unsigned int ao_readback[2];
 };
 
-#define devpriv ((struct dt2801_private *)dev->private)
-
 /* These are the low-level routines:
    writecommand: write a command to the board
    writedata: write data byte
@@ -508,6 +504,8 @@ static int dt2801_ao_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct dt2801_private *devpriv = dev->private;
+
 	data[0] = devpriv->ao_readback[CR_CHAN(insn->chanspec)];
 
 	return 1;
@@ -517,6 +515,8 @@ static int dt2801_ao_insn_write(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct dt2801_private *devpriv = dev->private;
+
 	dt2801_writecmd(dev, DT_C_WRITE_DAIM);
 	dt2801_writedata(dev, CR_CHAN(insn->chanspec));
 	dt2801_writedata2(dev, data[0]);
@@ -590,6 +590,8 @@ static int dt2801_dio_insn_config(struct comedi_device *dev,
 */
 static int dt2801_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct dt2801_board *boardtype;
+	struct dt2801_private *devpriv;
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	int board_code, type;
@@ -621,7 +623,8 @@ static int dt2801_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 havetype:
 	dev->board_ptr = boardtypes + type;
-	printk("dt2801: %s at port 0x%lx", boardtype.name, iobase);
+	boardtype = comedi_board(dev);
+	printk("dt2801: %s at port 0x%lx", boardtype->name, iobase);
 
 	n_ai_chans = probe_number_of_ai_chans(dev);
 	printk(" (ai channels = %d)\n", n_ai_chans);
@@ -630,11 +633,12 @@ havetype:
 	if (ret)
 		goto out;
 
-	ret = alloc_private(dev, sizeof(struct dt2801_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
-	dev->board_name = boardtype.name;
+	dev->board_name = boardtype->name;
 
 	s = dev->subdevices + 0;
 	/* ai subdevice */
@@ -644,12 +648,12 @@ havetype:
 	s->n_chan = n_ai_chans;
 #else
 	if (it->options[2])
-		s->n_chan = boardtype.ad_chan;
+		s->n_chan = boardtype->ad_chan;
 	else
-		s->n_chan = boardtype.ad_chan / 2;
+		s->n_chan = boardtype->ad_chan / 2;
 #endif
-	s->maxdata = (1 << boardtype.adbits) - 1;
-	s->range_table = ai_range_lkup(boardtype.adrangetype, it->options[3]);
+	s->maxdata = (1 << boardtype->adbits) - 1;
+	s->range_table = ai_range_lkup(boardtype->adrangetype, it->options[3]);
 	s->insn_read = dt2801_ai_insn_read;
 
 	s++;
@@ -657,7 +661,7 @@ havetype:
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
 	s->n_chan = 2;
-	s->maxdata = (1 << boardtype.dabits) - 1;
+	s->maxdata = (1 << boardtype->dabits) - 1;
 	s->range_table_list = devpriv->dac_range_types;
 	devpriv->dac_range_types[0] = dac_range_lkup(it->options[4]);
 	devpriv->dac_range_types[1] = dac_range_lkup(it->options[5]);
diff --git a/drivers/staging/comedi/drivers/dt2811.c b/drivers/staging/comedi/drivers/dt2811.c
index 290b933..1640f38 100644
--- a/drivers/staging/comedi/drivers/dt2811.c
+++ b/drivers/staging/comedi/drivers/dt2811.c
@@ -226,8 +226,6 @@ struct dt2811_private {
 	unsigned int ao_readback[2];
 };
 
-#define devpriv ((struct dt2811_private *)dev->private)
-
 static const struct comedi_lrange *dac_range_types[] = {
 	&range_bipolar5,
 	&range_bipolar2_5,
@@ -242,6 +240,7 @@ static irqreturn_t dt2811_interrupt(int irq, void *d)
 	int lo, hi;
 	int data;
 	struct comedi_device *dev = d;
+	struct dt2811_private *devpriv = dev->private;
 
 	if (!dev->attached) {
 		comedi_error(dev, "spurious interrupt");
@@ -318,6 +317,7 @@ int dt2811_adtrig(kdev_t minor, comedi_adtrig *adtrig)
 static int dt2811_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	struct dt2811_private *devpriv = dev->private;
 	int i;
 	int chan;
 
@@ -337,6 +337,7 @@ static int dt2811_ao_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct dt2811_private *devpriv = dev->private;
 	int i;
 	int chan;
 
@@ -397,6 +398,7 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* long flags; */
 
 	const struct dt2811_board *board = comedi_board(dev);
+	struct dt2811_private *devpriv;
 	int ret;
 	struct comedi_subdevice *s;
 	unsigned long iobase;
@@ -463,9 +465,10 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	ret = alloc_private(dev, sizeof(struct dt2811_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	switch (it->options[2]) {
 	case 0:
diff --git a/drivers/staging/comedi/drivers/dt2814.c b/drivers/staging/comedi/drivers/dt2814.c
index 2e39ebe..4f4aa37 100644
--- a/drivers/staging/comedi/drivers/dt2814.c
+++ b/drivers/staging/comedi/drivers/dt2814.c
@@ -66,8 +66,6 @@ struct dt2814_private {
 	int curadchan;
 };
 
-#define devpriv ((struct dt2814_private *)dev->private)
-
 #define DT2814_TIMEOUT 10
 #define DT2814_MAX_SPEED 100000	/* Arbitrary 10 khz limit */
 
@@ -218,6 +216,7 @@ static int dt2814_ai_cmdtest(struct comedi_device *dev,
 
 static int dt2814_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct dt2814_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int chan;
 	int trigvar;
@@ -239,6 +238,7 @@ static irqreturn_t dt2814_interrupt(int irq, void *d)
 {
 	int lo, hi;
 	struct comedi_device *dev = d;
+	struct dt2814_private *devpriv = dev->private;
 	struct comedi_subdevice *s;
 	int data;
 
@@ -276,6 +276,7 @@ static irqreturn_t dt2814_interrupt(int irq, void *d)
 
 static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	struct dt2814_private *devpriv;
 	int i, irq;
 	int ret;
 	struct comedi_subdevice *s;
@@ -342,9 +343,10 @@ static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	ret = alloc_private(dev, sizeof(struct dt2814_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	s = dev->subdevices + 0;
 	dev->read_subdev = s;
diff --git a/drivers/staging/comedi/drivers/dt2815.c b/drivers/staging/comedi/drivers/dt2815.c
index 45b20be..a7873ce 100644
--- a/drivers/staging/comedi/drivers/dt2815.c
+++ b/drivers/staging/comedi/drivers/dt2815.c
@@ -78,8 +78,6 @@ struct dt2815_private {
 	unsigned int ao_readback[8];
 };
 
-#define devpriv ((struct dt2815_private *)dev->private)
-
 static int dt2815_wait_for_status(struct comedi_device *dev, int status)
 {
 	int i;
@@ -95,6 +93,7 @@ static int dt2815_ao_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct dt2815_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -107,6 +106,7 @@ static int dt2815_ao_insn_read(struct comedi_device *dev,
 static int dt2815_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	struct dt2815_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 	unsigned int status;
@@ -162,6 +162,7 @@ static int dt2815_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 
 static int dt2815_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	struct dt2815_private *devpriv;
 	struct comedi_subdevice *s;
 	int i;
 	const struct comedi_lrange *current_range_type, *voltage_range_type;
@@ -182,8 +183,9 @@ static int dt2815_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	if (alloc_private(dev, sizeof(struct dt2815_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	s = dev->subdevices;
 	/* ao subdevice */
diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 1f0b40e..d4f2a0c 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -248,9 +248,6 @@ struct dt282x_private {
 	int dma_dir;
 };
 
-#define devpriv ((struct dt282x_private *)dev->private)
-#define boardtype (*(const struct dt282x_board *)dev->board_ptr)
-
 /*
  *    Some useless abstractions
  */
@@ -290,13 +287,15 @@ static int dt282x_grab_dma(struct comedi_device *dev, int dma1, int dma2);
 static void dt282x_munge(struct comedi_device *dev, short *buf,
 			 unsigned int nbytes)
 {
+	const struct dt282x_board *board = comedi_board(dev);
+	struct dt282x_private *devpriv = dev->private;
 	unsigned int i;
-	unsigned short mask = (1 << boardtype.adbits) - 1;
-	unsigned short sign = 1 << (boardtype.adbits - 1);
+	unsigned short mask = (1 << board->adbits) - 1;
+	unsigned short sign = 1 << (board->adbits - 1);
 	int n;
 
 	if (devpriv->ad_2scomp)
-		sign = 1 << (boardtype.adbits - 1);
+		sign = 1 << (board->adbits - 1);
 	else
 		sign = 0;
 
@@ -309,6 +308,7 @@ static void dt282x_munge(struct comedi_device *dev, short *buf,
 
 static void dt282x_ao_dma_interrupt(struct comedi_device *dev)
 {
+	struct dt282x_private *devpriv = dev->private;
 	void *ptr;
 	int size;
 	int i;
@@ -341,6 +341,7 @@ static void dt282x_ao_dma_interrupt(struct comedi_device *dev)
 
 static void dt282x_ai_dma_interrupt(struct comedi_device *dev)
 {
+	struct dt282x_private *devpriv = dev->private;
 	void *ptr;
 	int size;
 	int i;
@@ -393,6 +394,7 @@ static void dt282x_ai_dma_interrupt(struct comedi_device *dev)
 
 static int prep_ai_dma(struct comedi_device *dev, int dma_index, int n)
 {
+	struct dt282x_private *devpriv = dev->private;
 	int dma_chan;
 	unsigned long dma_ptr;
 	unsigned long flags;
@@ -424,6 +426,7 @@ static int prep_ai_dma(struct comedi_device *dev, int dma_index, int n)
 
 static int prep_ao_dma(struct comedi_device *dev, int dma_index, int n)
 {
+	struct dt282x_private *devpriv = dev->private;
 	int dma_chan;
 	unsigned long dma_ptr;
 	unsigned long flags;
@@ -447,6 +450,7 @@ static int prep_ao_dma(struct comedi_device *dev, int dma_index, int n)
 static irqreturn_t dt282x_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct dt282x_private *devpriv = dev->private;
 	struct comedi_subdevice *s;
 	struct comedi_subdevice *s_ao;
 	unsigned int supcsr, adcsr, dacsr;
@@ -492,14 +496,15 @@ static irqreturn_t dt282x_interrupt(int irq, void *d)
 	}
 #if 0
 	if (adcsr & DT2821_ADDONE) {
+		const struct dt282x_board *board = comedi_board(dev);
 		int ret;
 		short data;
 
 		data = (short)inw(dev->iobase + DT2821_ADDAT);
-		data &= (1 << boardtype.adbits) - 1;
+		data &= (1 << board->adbits) - 1;
 
 		if (devpriv->ad_2scomp)
-			data ^= 1 << (boardtype.adbits - 1);
+			data ^= 1 << (board->adbits - 1);
 		ret = comedi_buf_put(s->async, data);
 
 		if (ret == 0)
@@ -525,6 +530,7 @@ static irqreturn_t dt282x_interrupt(int irq, void *d)
 static void dt282x_load_changain(struct comedi_device *dev, int n,
 				 unsigned int *chanlist)
 {
+	struct dt282x_private *devpriv = dev->private;
 	unsigned int i;
 	unsigned int chan, range;
 
@@ -548,6 +554,8 @@ static int dt282x_ai_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	const struct dt282x_board *board = comedi_board(dev);
+	struct dt282x_private *devpriv = dev->private;
 	int i;
 
 	/* XXX should we really be enabling the ad clock here? */
@@ -567,9 +575,9 @@ static int dt282x_ai_insn_read(struct comedi_device *dev,
 
 		data[i] =
 		    inw(dev->iobase +
-			DT2821_ADDAT) & ((1 << boardtype.adbits) - 1);
+			DT2821_ADDAT) & ((1 << board->adbits) - 1);
 		if (devpriv->ad_2scomp)
-			data[i] ^= (1 << (boardtype.adbits - 1));
+			data[i] ^= (1 << (board->adbits - 1));
 	}
 
 	return i;
@@ -694,6 +702,7 @@ static int dt282x_ai_cmdtest(struct comedi_device *dev,
 static int dt282x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	const struct dt282x_board *board = comedi_board(dev);
+	struct dt282x_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int timer;
 
@@ -756,6 +765,8 @@ static int dt282x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 static void dt282x_disable_dma(struct comedi_device *dev)
 {
+	struct dt282x_private *devpriv = dev->private;
+
 	if (devpriv->usedma) {
 		disable_dma(devpriv->dma[0].chan);
 		disable_dma(devpriv->dma[1].chan);
@@ -765,6 +776,8 @@ static void dt282x_disable_dma(struct comedi_device *dev)
 static int dt282x_ai_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	struct dt282x_private *devpriv = dev->private;
+
 	dt282x_disable_dma(dev);
 
 	devpriv->adcsr = 0;
@@ -817,6 +830,8 @@ static int dt282x_ao_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct dt282x_private *devpriv = dev->private;
+
 	data[0] = devpriv->ao[CR_CHAN(insn->chanspec)];
 
 	return 1;
@@ -826,12 +841,14 @@ static int dt282x_ao_insn_write(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	const struct dt282x_board *board = comedi_board(dev);
+	struct dt282x_private *devpriv = dev->private;
 	short d;
 	unsigned int chan;
 
 	chan = CR_CHAN(insn->chanspec);
 	d = data[0];
-	d &= (1 << boardtype.dabits) - 1;
+	d &= (1 << board->dabits) - 1;
 	devpriv->ao[chan] = d;
 
 	devpriv->dacsr |= DT2821_SSEL;
@@ -840,11 +857,11 @@ static int dt282x_ao_insn_write(struct comedi_device *dev,
 		/* select channel */
 		devpriv->dacsr |= DT2821_YSEL;
 		if (devpriv->da0_2scomp)
-			d ^= (1 << (boardtype.dabits - 1));
+			d ^= (1 << (board->dabits - 1));
 	} else {
 		devpriv->dacsr &= ~DT2821_YSEL;
 		if (devpriv->da1_2scomp)
-			d ^= (1 << (boardtype.dabits - 1));
+			d ^= (1 << (board->dabits - 1));
 	}
 
 	outw(devpriv->dacsr, dev->iobase + DT2821_DACSR);
@@ -953,6 +970,7 @@ static int dt282x_ao_cmdtest(struct comedi_device *dev,
 static int dt282x_ao_inttrig(struct comedi_device *dev,
 			     struct comedi_subdevice *s, unsigned int x)
 {
+	struct dt282x_private *devpriv = dev->private;
 	int size;
 
 	if (x != 0)
@@ -982,6 +1000,7 @@ static int dt282x_ao_inttrig(struct comedi_device *dev,
 
 static int dt282x_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct dt282x_private *devpriv = dev->private;
 	int timer;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
@@ -1018,6 +1037,8 @@ static int dt282x_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 static int dt282x_ao_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	struct dt282x_private *devpriv = dev->private;
+
 	dt282x_disable_dma(dev);
 
 	devpriv->dacsr = 0;
@@ -1048,6 +1069,7 @@ static int dt282x_dio_insn_config(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct dt282x_private *devpriv = dev->private;
 	int mask;
 
 	mask = (CR_CHAN(insn->chanspec) < 8) ? 0x00ff : 0xff00;
@@ -1119,6 +1141,7 @@ enum {  /* i/o base, irq, dma channels */
 
 static int dt282x_grab_dma(struct comedi_device *dev, int dma1, int dma2)
 {
+	struct dt282x_private *devpriv = dev->private;
 	int ret;
 
 	devpriv->usedma = 0;
@@ -1180,6 +1203,7 @@ static int dt282x_grab_dma(struct comedi_device *dev, int dma1, int dma2)
 static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct dt282x_board *board = comedi_board(dev);
+	struct dt282x_private *devpriv;
 	int i, irq;
 	int ret;
 	struct comedi_subdevice *s;
@@ -1262,9 +1286,10 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif
 	}
 
-	ret = alloc_private(dev, sizeof(struct dt282x_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	ret = dt282x_grab_dma(dev, it->options[opt_dma1],
 			      it->options[opt_dma2]);
@@ -1283,20 +1308,20 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->subdev_flags = SDF_READABLE | SDF_CMD_READ |
 	    ((it->options[opt_diff]) ? SDF_DIFF : SDF_COMMON);
 	s->n_chan =
-	    (it->options[opt_diff]) ? boardtype.adchan_di : boardtype.adchan_se;
+	    (it->options[opt_diff]) ? board->adchan_di : board->adchan_se;
 	s->insn_read = dt282x_ai_insn_read;
 	s->do_cmdtest = dt282x_ai_cmdtest;
 	s->do_cmd = dt282x_ai_cmd;
 	s->cancel = dt282x_ai_cancel;
-	s->maxdata = (1 << boardtype.adbits) - 1;
+	s->maxdata = (1 << board->adbits) - 1;
 	s->len_chanlist = 16;
 	s->range_table =
-	    opt_ai_range_lkup(boardtype.ispgl, it->options[opt_ai_range]);
+	    opt_ai_range_lkup(board->ispgl, it->options[opt_ai_range]);
 	devpriv->ad_2scomp = it->options[opt_ai_twos];
 
 	s++;
 
-	s->n_chan = boardtype.dachan;
+	s->n_chan = board->dachan;
 	if (s->n_chan) {
 		/* ao subsystem */
 		s->type = COMEDI_SUBD_AO;
@@ -1307,7 +1332,7 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->do_cmdtest = dt282x_ao_cmdtest;
 		s->do_cmd = dt282x_ao_cmd;
 		s->cancel = dt282x_ao_cancel;
-		s->maxdata = (1 << boardtype.dabits) - 1;
+		s->maxdata = (1 << board->dabits) - 1;
 		s->len_chanlist = 2;
 		s->range_table_list = devpriv->darangelist;
 		devpriv->darangelist[0] =
@@ -1337,11 +1362,13 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void dt282x_detach(struct comedi_device *dev)
 {
+	struct dt282x_private *devpriv = dev->private;
+
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->iobase)
 		release_region(dev->iobase, DT2821_SIZE);
-	if (dev->private) {
+	if (devpriv) {
 		if (devpriv->dma[0].chan)
 			free_dma(devpriv->dma[0].chan);
 		if (devpriv->dma[1].chan)
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index d1d99a3..3f1c152 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -160,7 +160,6 @@ static const struct dt3k_boardtype dt3k_boardtypes[] = {
 };
 
 #define n_dt3k_boards sizeof(dt3k_boardtypes)/sizeof(struct dt3k_boardtype)
-#define this_board ((const struct dt3k_boardtype *)dev->board_ptr)
 
 #define DT3000_SIZE		(4*0x1000)
 
@@ -259,8 +258,6 @@ struct dt3k_private {
 	unsigned int ai_rear;
 };
 
-#define devpriv ((struct dt3k_private *)dev->private)
-
 static void dt3k_ai_empty_fifo(struct comedi_device *dev,
 			       struct comedi_subdevice *s);
 static int dt3k_ns_to_timer(unsigned int timer_base, unsigned int *arg,
@@ -275,6 +272,7 @@ static void debug_intr_flags(unsigned int flags);
 
 static int dt3k_send_cmd(struct comedi_device *dev, unsigned int cmd)
 {
+	struct dt3k_private *devpriv = dev->private;
 	int i;
 	unsigned int status = 0;
 
@@ -299,6 +297,8 @@ static unsigned int dt3k_readsingle(struct comedi_device *dev,
 				    unsigned int subsys, unsigned int chan,
 				    unsigned int gain)
 {
+	struct dt3k_private *devpriv = dev->private;
+
 	writew(subsys, devpriv->io_addr + DPR_SubSys);
 
 	writew(chan, devpriv->io_addr + DPR_Params(0));
@@ -312,6 +312,8 @@ static unsigned int dt3k_readsingle(struct comedi_device *dev,
 static void dt3k_writesingle(struct comedi_device *dev, unsigned int subsys,
 			     unsigned int chan, unsigned int data)
 {
+	struct dt3k_private *devpriv = dev->private;
+
 	writew(subsys, devpriv->io_addr + DPR_SubSys);
 
 	writew(chan, devpriv->io_addr + DPR_Params(0));
@@ -328,6 +330,7 @@ static int debug_n_ints;
 static irqreturn_t dt3k_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct dt3k_private *devpriv = dev->private;
 	struct comedi_subdevice *s;
 	unsigned int status;
 
@@ -379,6 +382,7 @@ static void debug_intr_flags(unsigned int flags)
 static void dt3k_ai_empty_fifo(struct comedi_device *dev,
 			       struct comedi_subdevice *s)
 {
+	struct dt3k_private *devpriv = dev->private;
 	int front;
 	int rear;
 	int count;
@@ -409,6 +413,7 @@ static void dt3k_ai_empty_fifo(struct comedi_device *dev,
 static int dt3k_ai_cmdtest(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
+	const struct dt3k_boardtype *this_board = comedi_board(dev);
 	int err = 0;
 	int tmp;
 
@@ -570,6 +575,7 @@ static int dt3k_ns_to_timer(unsigned int timer_base, unsigned int *nanosec,
 
 static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct dt3k_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int i;
 	unsigned int chan, range, aref;
@@ -638,6 +644,7 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 static int dt3k_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct dt3k_private *devpriv = dev->private;
 	int ret;
 
 	writew(SUBS_AI, devpriv->io_addr + DPR_SubSys);
@@ -668,6 +675,7 @@ static int dt3k_ai_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int dt3k_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			struct comedi_insn *insn, unsigned int *data)
 {
+	struct dt3k_private *devpriv = dev->private;
 	int i;
 	unsigned int chan;
 
@@ -684,6 +692,7 @@ static int dt3k_ao_insn_read(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data)
 {
+	struct dt3k_private *devpriv = dev->private;
 	int i;
 	unsigned int chan;
 
@@ -696,6 +705,8 @@ static int dt3k_ao_insn_read(struct comedi_device *dev,
 
 static void dt3k_dio_config(struct comedi_device *dev, int bits)
 {
+	struct dt3k_private *devpriv = dev->private;
+
 	/* XXX */
 	writew(SUBS_DOUT, devpriv->io_addr + DPR_SubSys);
 
@@ -759,6 +770,7 @@ static int dt3k_mem_insn_read(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
+	struct dt3k_private *devpriv = dev->private;
 	unsigned int addr = CR_CHAN(insn->chanspec);
 	int i;
 
@@ -777,6 +789,7 @@ static int dt3k_mem_insn_read(struct comedi_device *dev,
 
 static int setup_pci(struct comedi_device *dev)
 {
+	struct dt3k_private *devpriv = dev->private;
 	resource_size_t addr;
 	int ret;
 
@@ -820,6 +833,7 @@ static struct pci_dev *dt_pci_find_device(struct pci_dev *from, int *board)
 
 static int dt_pci_probe(struct comedi_device *dev, int bus, int slot)
 {
+	struct dt3k_private *devpriv = dev->private;
 	int board;
 	int ret;
 	struct pci_dev *pcidev;
@@ -849,6 +863,8 @@ static int dt_pci_probe(struct comedi_device *dev, int bus, int slot)
 
 static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct dt3k_boardtype *this_board;
+	struct dt3k_private *devpriv;
 	struct comedi_subdevice *s;
 	int bus, slot;
 	int ret = 0;
@@ -857,9 +873,10 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	bus = it->options[0];
 	slot = it->options[1];
 
-	ret = alloc_private(dev, sizeof(struct dt3k_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	ret = dt_pci_probe(dev, bus, slot);
 	if (ret < 0)
@@ -868,6 +885,7 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		dev_warn(dev->class_dev, "no DT board found\n");
 		return -ENODEV;
 	}
+	this_board = comedi_board(dev);
 
 	dev->board_name = this_board->name;
 
@@ -941,6 +959,8 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void dt3000_detach(struct comedi_device *dev)
 {
+	struct dt3k_private *devpriv = dev->private;
+
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (devpriv) {
diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 40821c7..67d9313 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -323,9 +323,6 @@ static const struct comedi_lrange dt9812_2pt5_aout_range = { 1, {
 
 static struct slot_dt9812 dt9812[DT9812_NUM_SLOTS];
 
-/* Useful shorthand access to private data */
-#define devpriv ((struct comedi_dt9812 *)dev->private)
-
 static inline struct usb_dt9812 *to_dt9812_dev(struct kref *d)
 {
 	return container_of(d, struct usb_dt9812, kref);
@@ -893,6 +890,7 @@ static struct usb_driver dt9812_usb_driver = {
 
 static int dt9812_comedi_open(struct comedi_device *dev)
 {
+	struct comedi_dt9812 *devpriv = dev->private;
 	int result = -ENODEV;
 
 	down(&devpriv->slot->mutex);
@@ -947,6 +945,7 @@ static int dt9812_di_rinsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
 {
+	struct comedi_dt9812 *devpriv = dev->private;
 	int n;
 	u8 bits = 0;
 
@@ -960,6 +959,7 @@ static int dt9812_do_winsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
 {
+	struct comedi_dt9812 *devpriv = dev->private;
 	int n;
 	u8 bits = 0;
 
@@ -979,6 +979,7 @@ static int dt9812_ai_rinsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
 {
+	struct comedi_dt9812 *devpriv = dev->private;
 	int n;
 
 	for (n = 0; n < insn->n; n++) {
@@ -995,6 +996,7 @@ static int dt9812_ao_rinsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
 {
+	struct comedi_dt9812 *devpriv = dev->private;
 	int n;
 	u16 value;
 
@@ -1010,6 +1012,7 @@ static int dt9812_ao_winsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
 {
+	struct comedi_dt9812 *devpriv = dev->private;
 	int n;
 
 	for (n = 0; n < insn->n; n++)
@@ -1019,14 +1022,16 @@ static int dt9812_ao_winsn(struct comedi_device *dev,
 
 static int dt9812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	struct comedi_dt9812 *devpriv;
 	int i;
 	struct comedi_subdevice *s;
 	int ret;
 
 	dev->board_name = "dt9812";
 
-	if (alloc_private(dev, sizeof(struct comedi_dt9812)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	/*
 	 * Special open routine, since USB unit may be unattached at
diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index e31f74a..3293d81 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -107,9 +107,6 @@ struct dyna_pci10xx_private {
 	unsigned long BADR3;
 };
 
-#define thisboard ((const struct boardtype *)dev->board_ptr)
-#define devpriv ((struct dyna_pci10xx_private *)dev->private)
-
 /******************************************************************************/
 /************************** READ WRITE FUNCTIONS ******************************/
 /******************************************************************************/
@@ -119,6 +116,8 @@ static int dyna_pci10xx_insn_read_ai(struct comedi_device *dev,
 			struct comedi_subdevice *s,
 			struct comedi_insn *insn, unsigned int *data)
 {
+	const struct boardtype *thisboard = comedi_board(dev);
+	struct dyna_pci10xx_private *devpriv = dev->private;
 	int n, counter;
 	u16 d = 0;
 	unsigned int chan, range;
@@ -162,6 +161,8 @@ static int dyna_pci10xx_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	const struct boardtype *thisboard = comedi_board(dev);
+	struct dyna_pci10xx_private *devpriv = dev->private;
 	int n;
 	unsigned int chan, range;
 
@@ -184,6 +185,7 @@ static int dyna_pci10xx_di_insn_bits(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
+	struct dyna_pci10xx_private *devpriv = dev->private;
 	u16 d = 0;
 
 	mutex_lock(&devpriv->mutex);
@@ -203,6 +205,8 @@ static int dyna_pci10xx_do_insn_bits(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
+	struct dyna_pci10xx_private *devpriv = dev->private;
+
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit.
 	 * s->state contains the previous write data
@@ -257,23 +261,27 @@ static struct pci_dev *dyna_pci10xx_find_pci_dev(struct comedi_device *dev,
 static int dyna_pci10xx_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct boardtype *thisboard;
+	struct dyna_pci10xx_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
 
 	mutex_lock(&start_stop_sem);
 
-	if (alloc_private(dev, sizeof(struct dyna_pci10xx_private)) < 0) {
+	if (alloc_private(dev, sizeof(*devpriv)) < 0) {
 		printk(KERN_ERR "comedi: dyna_pci10xx: "
 			"failed to allocate memory!\n");
 		mutex_unlock(&start_stop_sem);
 		return -ENOMEM;
 	}
+	devpriv = dev->private;
 
 	dev->pcidev = dyna_pci10xx_find_pci_dev(dev, it);
 	if (!dev->pcidev) {
 		mutex_unlock(&start_stop_sem);
 		return -EIO;
 	}
+	thisboard = comedi_board(dev);
 
 	dev->board_name = thisboard->name;
 	dev->irq = 0;
@@ -348,6 +356,8 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 
 static void dyna_pci10xx_detach(struct comedi_device *dev)
 {
+	struct dyna_pci10xx_private *devpriv = dev->private;
+
 	if (dev->pcidev)
 		comedi_pci_disable(dev->pcidev);
 	if (devpriv)
diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
index d1da809..af34417 100644
--- a/drivers/staging/comedi/drivers/fl512.c
+++ b/drivers/staging/comedi/drivers/fl512.c
@@ -29,8 +29,6 @@ struct fl512_private {
 	short ao_readback[2];
 };
 
-#define devpriv ((struct fl512_private *) dev->private)
-
 static const struct comedi_lrange range_fl512 = { 4, {
 						      BIP_RANGE(0.5),
 						      BIP_RANGE(1),
@@ -75,6 +73,7 @@ static int fl512_ao_insn(struct comedi_device *dev,
 			 struct comedi_subdevice *s, struct comedi_insn *insn,
 			 unsigned int *data)
 {
+	struct fl512_private *devpriv = dev->private;
 	int n;
 	int chan = CR_CHAN(insn->chanspec);	/* get chan to write */
 	unsigned long iobase = dev->iobase;	/* get base address  */
@@ -99,6 +98,7 @@ static int fl512_ao_insn_readback(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct fl512_private *devpriv = dev->private;
 	int n;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -110,6 +110,7 @@ static int fl512_ao_insn_readback(struct comedi_device *dev,
 
 static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	struct fl512_private *devpriv;
 	unsigned long iobase;
 	int ret;
 
@@ -125,8 +126,10 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	dev->iobase = iobase;
 	dev->board_name = "fl512";
-	if (alloc_private(dev, sizeof(struct fl512_private)) < 0)
+
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 #if DEBUG
 	printk(KERN_DEBUG "malloc ok\n");
diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index b10ebdb..0283d49 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -164,9 +164,6 @@ struct icp_multi_private {
 	unsigned int do_data;	/*  Remember digital output data */
 };
 
-#define devpriv ((struct icp_multi_private *)dev->private)
-#define this_board ((const struct boardtype *)dev->board_ptr)
-
 /*
 ==============================================================================
 
@@ -191,6 +188,8 @@ static void setup_channel_list(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       unsigned int *chanlist, unsigned int n_chan)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct icp_multi_private *devpriv = dev->private;
 	unsigned int i, range, chanprog;
 	unsigned int diff;
 
@@ -267,6 +266,7 @@ static int icp_multi_insn_read_ai(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct icp_multi_private *devpriv = dev->private;
 	int n, timeout;
 
 #ifdef ICP_MULTI_EXTDEBUG
@@ -391,6 +391,8 @@ static int icp_multi_insn_write_ao(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn, unsigned int *data)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct icp_multi_private *devpriv = dev->private;
 	int n, chan, range, timeout;
 
 #ifdef ICP_MULTI_EXTDEBUG
@@ -506,6 +508,7 @@ static int icp_multi_insn_read_ao(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct icp_multi_private *devpriv = dev->private;
 	int n, chan;
 
 	/*  Get channel number */
@@ -540,6 +543,8 @@ static int icp_multi_insn_bits_di(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct icp_multi_private *devpriv = dev->private;
+
 	data[1] = readw(devpriv->io_addr + ICP_MULTI_DI);
 
 	return insn->n;
@@ -567,6 +572,8 @@ static int icp_multi_insn_bits_do(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct icp_multi_private *devpriv = dev->private;
+
 #ifdef ICP_MULTI_EXTDEBUG
 	printk(KERN_DEBUG "icp multi EDBG: BGN: icp_multi_insn_bits_do(...)\n");
 #endif
@@ -657,6 +664,7 @@ Parameters:
 static irqreturn_t interrupt_service_icp_multi(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct icp_multi_private *devpriv = dev->private;
 	int int_no;
 
 #ifdef ICP_MULTI_EXTDEBUG
@@ -732,6 +740,7 @@ static int check_channel_list(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      unsigned int *chanlist, unsigned int n_chan)
 {
+	const struct boardtype *this_board = comedi_board(dev);
 	unsigned int i;
 
 #ifdef ICP_MULTI_EXTDEBUG
@@ -781,6 +790,8 @@ Returns:int	0 = success
 */
 static int icp_multi_reset(struct comedi_device *dev)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct icp_multi_private *devpriv = dev->private;
 	unsigned int i;
 
 #ifdef ICP_MULTI_EXTDEBUG
@@ -825,6 +836,8 @@ static int icp_multi_reset(struct comedi_device *dev)
 static int icp_multi_attach(struct comedi_device *dev,
 			    struct comedi_devconfig *it)
 {
+	const struct boardtype *this_board = comedi_board(dev);
+	struct icp_multi_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret, subdev, n_subdevices;
 	unsigned int irq;
@@ -836,9 +849,10 @@ static int icp_multi_attach(struct comedi_device *dev,
 	       "icp_multi EDBG: BGN: icp_multi_attach(...)\n");
 
 	/*  Allocate private data storage space */
-	ret = alloc_private(dev, sizeof(struct icp_multi_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	/*  Initialise list of PCI cards in system, if not already done so */
 	if (pci_list_builded++ == 0) {
@@ -1009,15 +1023,19 @@ static int icp_multi_attach(struct comedi_device *dev,
 
 static void icp_multi_detach(struct comedi_device *dev)
 {
-	if (dev->private)
+	struct icp_multi_private *devpriv = dev->private;
+
+	if (devpriv)
 		if (devpriv->valid)
 			icp_multi_reset(dev);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-	if (dev->private && devpriv->io_addr)
-		iounmap(devpriv->io_addr);
-	if (dev->private && devpriv->card)
-		pci_card_free(devpriv->card);
+	if (devpriv) {
+		if (devpriv->io_addr)
+			iounmap(devpriv->io_addr);
+		if (devpriv->card)
+			pci_card_free(devpriv->card);
+	}
 	if (--pci_list_builded == 0)
 		pci_card_list_cleanup(PCI_VENDOR_ID_ICP);
 }
diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index 0f9cfe6..0b7fbe8 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -156,7 +156,6 @@ struct pci20xxx_private {
 	union pci20xxx_subdev_private subdev_private[PCI20000_MODULES];
 };
 
-#define devpriv ((struct pci20xxx_private *)dev->private)
 #define CHAN (CR_CHAN(it->chanlist[0]))
 
 static int pci20006_init(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -196,6 +195,7 @@ static int pci20xxx_dio_init(struct comedi_device *dev,
 static int pci20xxx_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
+	struct pci20xxx_private *devpriv;
 	unsigned char i;
 	int ret;
 	int id;
@@ -206,9 +206,10 @@ static int pci20xxx_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	ret = alloc_private(dev, sizeof(struct pci20xxx_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	devpriv->ioaddr = (void __iomem *)(unsigned long)it->options[0];
 	dev->board_name = "pci20kc";
@@ -541,6 +542,7 @@ static int pci20xxx_dio_insn_bits(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci20xxx_private *devpriv = dev->private;
 	unsigned int mask = data[0];
 
 	s->state &= ~mask;
@@ -571,6 +573,7 @@ static int pci20xxx_dio_insn_bits(struct comedi_device *dev,
 static void pci20xxx_dio_config(struct comedi_device *dev,
 				struct comedi_subdevice *s)
 {
+	struct pci20xxx_private *devpriv = dev->private;
 	unsigned char control_01;
 	unsigned char control_23;
 	unsigned char buffer;
@@ -627,6 +630,8 @@ static void pci20xxx_dio_config(struct comedi_device *dev,
 #if 0
 static void pci20xxx_do(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct pci20xxx_private *devpriv = dev->private;
+
 	/* XXX if the channel is configured for input, does this
 	   do bad things? */
 	/* XXX it would be a good idea to only update the registers
@@ -641,6 +646,7 @@ static void pci20xxx_do(struct comedi_device *dev, struct comedi_subdevice *s)
 static unsigned int pci20xxx_di(struct comedi_device *dev,
 				struct comedi_subdevice *s)
 {
+	struct pci20xxx_private *devpriv = dev->private;
 	/* XXX same note as above */
 	unsigned int bits;
 
diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 93f94cd..9c04874 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -761,11 +761,12 @@ static int jr3_pci_attach(struct comedi_device *dev,
 		return -EINVAL;
 	}
 
-	result = alloc_private(dev, sizeof(struct jr3_pci_dev_private));
+	result = alloc_private(dev, sizeof(*devpriv));
 	if (result < 0)
 		return -ENOMEM;
-	card = NULL;
 	devpriv = dev->private;
+
+	card = NULL;
 	init_timer(&devpriv->timer);
 	while (1) {
 		card = pci_get_device(PCI_VENDOR_ID_JR3, PCI_ANY_ID, card);
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 9a8258e..632689d 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -123,13 +123,15 @@ static const struct comedi_lrange me4000_ao_range = {
 
 static int me4000_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct me4000_board *board;
+	struct me4000_info *info;
 	struct pci_dev *pci_device = NULL;
 	int result, i;
-	struct me4000_board *board;
 
 	/* Allocate private memory */
-	if (alloc_private(dev, sizeof(struct me4000_info)) < 0)
+	if (alloc_private(dev, sizeof(*info)) < 0)
 		return -ENOMEM;
+	info = dev->private;
 
 	/*
 	 * Probe the device to determine what device in the series it is.
@@ -158,9 +160,7 @@ static int me4000_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 						}
 					}
 					dev->board_ptr = me4000_boards + i;
-					board =
-					    (struct me4000_board *)
-					    dev->board_ptr;
+					board = comedi_board(dev);
 					info->pci_dev_p = pci_device;
 					goto found;
 				}
@@ -270,6 +270,8 @@ found:
 
 static int get_registers(struct comedi_device *dev, struct pci_dev *pci_dev_p)
 {
+	struct me4000_info *info = dev->private;
+
     /*--------------------------- plx regbase -------------------------------*/
 
 	info->plx_regbase = pci_resource_start(pci_dev_p, 1);
@@ -319,6 +321,7 @@ static int get_registers(struct comedi_device *dev, struct pci_dev *pci_dev_p)
 
 static int init_board_info(struct comedi_device *dev, struct pci_dev *pci_dev_p)
 {
+	struct me4000_info *info = dev->private;
 	int result;
 
 	/* Init spin locks */
@@ -349,6 +352,8 @@ static int init_board_info(struct comedi_device *dev, struct pci_dev *pci_dev_p)
 
 static int init_ao_context(struct comedi_device *dev)
 {
+	const struct me4000_board *thisboard = comedi_board(dev);
+	struct me4000_info *info = dev->private;
 	int i;
 
 	for (i = 0; i < thisboard->ao.count; i++) {
@@ -430,6 +435,8 @@ static int init_ao_context(struct comedi_device *dev)
 
 static int init_ai_context(struct comedi_device *dev)
 {
+	struct me4000_info *info = dev->private;
+
 	info->ai_context.irq = info->irq;
 
 	info->ai_context.ctrl_reg = info->me4000_regbase + ME4000_AI_CTRL_REG;
@@ -461,6 +468,8 @@ static int init_ai_context(struct comedi_device *dev)
 
 static int init_dio_context(struct comedi_device *dev)
 {
+	struct me4000_info *info = dev->private;
+
 	info->dio_context.dir_reg = info->me4000_regbase + ME4000_DIO_DIR_REG;
 	info->dio_context.ctrl_reg = info->me4000_regbase + ME4000_DIO_CTRL_REG;
 	info->dio_context.port_0_reg =
@@ -477,6 +486,8 @@ static int init_dio_context(struct comedi_device *dev)
 
 static int init_cnt_context(struct comedi_device *dev)
 {
+	struct me4000_info *info = dev->private;
+
 	info->cnt_context.ctrl_reg = info->timer_regbase + ME4000_CNT_CTRL_REG;
 	info->cnt_context.counter_0_reg =
 	    info->timer_regbase + ME4000_CNT_COUNTER_0_REG;
@@ -495,6 +506,7 @@ extern unsigned char *xilinx_firm;
 
 static int xilinx_download(struct comedi_device *dev)
 {
+	struct me4000_info *info = dev->private;
 	u32 value = 0;
 	wait_queue_head_t queue;
 	int idx = 0;
@@ -576,6 +588,7 @@ static int xilinx_download(struct comedi_device *dev)
 
 static int reset_board(struct comedi_device *dev)
 {
+	struct me4000_info *info = dev->private;
 	unsigned long icr;
 
 	/* Make a hardware reset */
@@ -630,7 +643,8 @@ static int me4000_ai_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *subdevice,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-
+	const struct me4000_board *thisboard = comedi_board(dev);
+	struct me4000_info *info = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 	int rang = CR_RANGE(insn->chanspec);
 	int aref = CR_AREF(insn->chanspec);
@@ -752,6 +766,7 @@ static int me4000_ai_insn_read(struct comedi_device *dev,
 static int me4000_ai_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	struct me4000_info *info = dev->private;
 	unsigned long tmp;
 
 	/* Stop any running conversion */
@@ -768,6 +783,7 @@ static int me4000_ai_cancel(struct comedi_device *dev,
 static int ai_check_chanlist(struct comedi_device *dev,
 			     struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
+	const struct me4000_board *thisboard = comedi_board(dev);
 	int aref;
 	int i;
 
@@ -906,6 +922,8 @@ static void ai_write_timer(struct comedi_device *dev,
 			   unsigned int init_ticks,
 			   unsigned int scan_ticks, unsigned int chan_ticks)
 {
+	struct me4000_info *info = dev->private;
+
 	outl(init_ticks - 1, info->ai_context.scan_pre_timer_low_reg);
 	outl(0x0, info->ai_context.scan_pre_timer_high_reg);
 
@@ -924,7 +942,7 @@ static int ai_prepare(struct comedi_device *dev,
 		      unsigned int init_ticks,
 		      unsigned int scan_ticks, unsigned int chan_ticks)
 {
-
+	struct me4000_info *info = dev->private;
 	unsigned long tmp = 0;
 
 	/* Write timer arguments */
@@ -988,6 +1006,7 @@ static int ai_prepare(struct comedi_device *dev,
 static int ai_write_chanlist(struct comedi_device *dev,
 			     struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
+	struct me4000_info *info = dev->private;
 	unsigned int entry;
 	unsigned int chan;
 	unsigned int rang;
@@ -1024,6 +1043,7 @@ static int ai_write_chanlist(struct comedi_device *dev,
 static int me4000_ai_do_cmd(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	struct me4000_info *info = dev->private;
 	int err;
 	unsigned int init_ticks = 0;
 	unsigned int scan_ticks = 0;
@@ -1410,6 +1430,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 {
 	unsigned int tmp;
 	struct comedi_device *dev = dev_id;
+	struct me4000_info *info = dev->private;
 	struct comedi_subdevice *s = dev->subdevices;
 	struct me4000_ai_context *ai_context = &info->ai_context;
 	int i;
@@ -1562,7 +1583,8 @@ static int me4000_ao_insn_write(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
-
+	const struct me4000_board *thisboard = comedi_board(dev);
+	struct me4000_info *info = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 	int rang = CR_RANGE(insn->chanspec);
 	int aref = CR_AREF(insn->chanspec);
@@ -1619,6 +1641,7 @@ static int me4000_ao_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct me4000_info *info = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 
 	if (insn->n == 0) {
@@ -1643,6 +1666,8 @@ static int me4000_dio_insn_bits(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct me4000_info *info = dev->private;
+
 	/*
 	 * The insn data consists of a mask in data[0] and the new data
 	 * in data[1]. The mask defines which bits we are concerning about.
@@ -1682,6 +1707,7 @@ static int me4000_dio_insn_config(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct me4000_info *info = dev->private;
 	unsigned long tmp;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -1780,6 +1806,8 @@ static int me4000_dio_insn_config(struct comedi_device *dev,
 
 static int cnt_reset(struct comedi_device *dev, unsigned int channel)
 {
+	struct me4000_info *info = dev->private;
+
 	switch (channel) {
 	case 0:
 		outb(0x30, info->cnt_context.ctrl_reg);
@@ -1809,6 +1837,7 @@ static int cnt_reset(struct comedi_device *dev, unsigned int channel)
 static int cnt_config(struct comedi_device *dev, unsigned int channel,
 		      unsigned int mode)
 {
+	struct me4000_info *info = dev->private;
 	int tmp = 0;
 
 	switch (channel) {
@@ -1909,7 +1938,7 @@ static int me4000_cnt_insn_read(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
-
+	struct me4000_info *info = dev->private;
 	unsigned short tmp;
 
 	if (insn->n == 0)
@@ -1957,7 +1986,7 @@ static int me4000_cnt_insn_write(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
-
+	struct me4000_info *info = dev->private;
 	unsigned short tmp;
 
 	if (insn->n == 0) {
@@ -2002,12 +2031,16 @@ static int me4000_cnt_insn_write(struct comedi_device *dev,
 
 static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct me4000_board *thisboard;
+	struct me4000_info *info;
 	struct comedi_subdevice *s;
 	int result;
 
 	result = me4000_probe(dev, it);
 	if (result)
 		return result;
+	info = dev->private;
+	thisboard = comedi_board(dev);
 
 	result = comedi_alloc_subdevices(dev, 4);
 	if (result)
@@ -2119,6 +2152,8 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void me4000_detach(struct comedi_device *dev)
 {
+	struct me4000_info *info = dev->private;
+
 	if (info) {
 		if (info->pci_dev_p) {
 			reset_board(dev);
diff --git a/drivers/staging/comedi/drivers/me4000.h b/drivers/staging/comedi/drivers/me4000.h
index 5a4df4e..7d69f69 100644
--- a/drivers/staging/comedi/drivers/me4000.h
+++ b/drivers/staging/comedi/drivers/me4000.h
@@ -285,8 +285,6 @@ struct me4000_board {
 	struct me4000_cnt_info cnt;
 };
 
-#define thisboard ((const struct me4000_board *)dev->board_ptr)
-
 /*=============================================================================
   Global board and subdevice information structures
   ===========================================================================*/
@@ -365,8 +363,6 @@ struct me4000_info {
 	struct me4000_cnt_context cnt_context;	/*  Counter specific context */
 };
 
-#define info	((struct me4000_info *)dev->private)
-
 /*-----------------------------------------------------------------------------
   Defines for analog input
  ----------------------------------------------------------------------------*/
diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index 1803d66..df341c9 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -247,8 +247,6 @@ struct me_private_data {
 	int ao_readback[4];	/* Mirror of analog output data */
 };
 
-#define dev_private ((struct me_private_data *)dev->private)
-
 /*
  * ------------------------------------------------------------------
  *
@@ -273,6 +271,7 @@ static int me_dio_insn_config(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
+	struct me_private_data *dev_private = dev->private;
 	int bits;
 	int mask = 1 << CR_CHAN(insn->chanspec);
 
@@ -310,7 +309,9 @@ static int me_dio_insn_bits(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct me_private_data *dev_private = dev->private;
 	unsigned int mask = data[0];
+
 	s->state &= ~mask;
 	s->state |= (mask & data[1]);
 
@@ -347,6 +348,7 @@ static int me_ai_insn_read(struct comedi_device *dev,
 			   struct comedi_subdevice *subdevice,
 			   struct comedi_insn *insn, unsigned int *data)
 {
+	struct me_private_data *dev_private = dev->private;
 	unsigned short value;
 	int chan = CR_CHAN((&insn->chanspec)[0]);
 	int rang = CR_RANGE((&insn->chanspec)[0]);
@@ -420,6 +422,8 @@ static int me_ai_insn_read(struct comedi_device *dev,
 /* Cancel analog input autoscan */
 static int me_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct me_private_data *dev_private = dev->private;
+
 	/* disable interrupts */
 
 	/* stop any running conversion */
@@ -456,6 +460,7 @@ static int me_ao_insn_write(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct me_private_data *dev_private = dev->private;
 	int chan;
 	int rang;
 	int i;
@@ -507,6 +512,7 @@ static int me_ao_insn_read(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
 {
+	struct me_private_data *dev_private = dev->private;
 	int i;
 
 	for (i = 0; i < insn->n; i++) {
@@ -530,6 +536,7 @@ static int me2600_xilinx_download(struct comedi_device *dev,
 				  unsigned char *me2600_firmware,
 				  unsigned int length)
 {
+	struct me_private_data *dev_private = dev->private;
 	unsigned int value;
 	unsigned int file_length;
 	unsigned int i;
@@ -596,6 +603,8 @@ static int me2600_xilinx_download(struct comedi_device *dev,
 /* Reset device */
 static int me_reset(struct comedi_device *dev)
 {
+	struct me_private_data *dev_private = dev->private;
+
 	/* Reset board */
 	writew(0x00, dev_private->me_regbase + ME_CONTROL_1);
 	writew(0x00, dev_private->me_regbase + ME_CONTROL_2);
@@ -612,9 +621,10 @@ static int me_reset(struct comedi_device *dev)
 
 static int me_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct me_board *board;
+	struct me_private_data *dev_private;
 	struct pci_dev *pci_device = NULL;
 	struct comedi_subdevice *subdevice;
-	struct me_board *board;
 	resource_size_t plx_regbase_tmp;
 	unsigned long plx_regbase_size_tmp;
 	resource_size_t me_regbase_tmp;
@@ -625,8 +635,9 @@ static int me_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int result, error, i;
 
 	/* Allocate private memory */
-	if (alloc_private(dev, sizeof(struct me_private_data)) < 0)
+	if (alloc_private(dev, sizeof(*dev_private)) < 0)
 		return -ENOMEM;
+	dev_private = dev->private;
 
 	/* Probe the device to determine what device in the series it is. */
 	for_each_pci_dev(pci_device) {
@@ -652,8 +663,6 @@ static int me_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 					}
 
 					dev->board_ptr = me_boards + i;
-					board =
-					    (struct me_board *)dev->board_ptr;
 					dev_private->pci_device = pci_device;
 					goto found;
 				}
@@ -667,8 +676,10 @@ static int me_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return -EIO;
 
 found:
+	board = comedi_board(dev);
+
 	printk(KERN_INFO "comedi%d: found %s at PCI bus %d, slot %d\n",
-	       dev->minor, me_boards[i].name,
+	       dev->minor, board->name,
 	       pci_device->bus->number, PCI_SLOT(pci_device->devfn));
 
 	/* Enable PCI device and request PCI regions */
@@ -805,6 +816,8 @@ found:
 
 static void me_detach(struct comedi_device *dev)
 {
+	struct me_private_data *dev_private = dev->private;
+
 	if (dev_private) {
 		if (dev_private->me_regbase) {
 			me_reset(dev);
diff --git a/drivers/staging/comedi/drivers/mpc624.c b/drivers/staging/comedi/drivers/mpc624.c
index b928b67..e355cb2 100644
--- a/drivers/staging/comedi/drivers/mpc624.c
+++ b/drivers/staging/comedi/drivers/mpc624.c
@@ -128,7 +128,6 @@ struct skel_private {
 	unsigned long int ulConvertionRate;
 };
 
-#define devpriv ((struct skel_private *)dev->private)
 /* -------------------------------------------------------------------------- */
 static const struct comedi_lrange range_mpc624_bipolar1 = {
 	1,
@@ -155,6 +154,7 @@ static int mpc624_ai_rinsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
 {
+	struct skel_private *devpriv = dev->private;
 	int n, i;
 	unsigned long int data_in, data_out;
 	unsigned char ucPort;
@@ -283,6 +283,7 @@ static int mpc624_ai_rinsn(struct comedi_device *dev,
 
 static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	struct skel_private *devpriv;
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	int ret;
@@ -298,8 +299,9 @@ static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->board_name = "mpc624";
 
 	/*  Private structure initialization */
-	if (alloc_private(dev, sizeof(struct skel_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	switch (it->options[1]) {
 	case 0:
diff --git a/drivers/staging/comedi/drivers/mpc8260cpm.c b/drivers/staging/comedi/drivers/mpc8260cpm.c
index a7fda8f..7ed1f78 100644
--- a/drivers/staging/comedi/drivers/mpc8260cpm.c
+++ b/drivers/staging/comedi/drivers/mpc8260cpm.c
@@ -38,14 +38,6 @@ It is apparently missing some code.
 
 extern unsigned long mpc8260_dio_reserved[4];
 
-struct mpc8260cpm_private {
-
-	int data;
-
-};
-
-#define devpriv ((struct mpc8260cpm_private *)dev->private)
-
 static unsigned long *cpm_pdat(int port)
 {
 	switch (port) {
@@ -129,9 +121,6 @@ static int mpc8260cpm_attach(struct comedi_device *dev,
 
 	dev->board_name = thisboard->name;
 
-	if (alloc_private(dev, sizeof(struct mpc8260cpm_private)) < 0)
-		return -ENOMEM;
-
 	ret =comedi_alloc_subdevices(dev, 4);
 	if (ret)
 		return ret;
diff --git a/drivers/staging/comedi/drivers/multiq3.c b/drivers/staging/comedi/drivers/multiq3.c
index eccbe1f..cbdf58a 100644
--- a/drivers/staging/comedi/drivers/multiq3.c
+++ b/drivers/staging/comedi/drivers/multiq3.c
@@ -86,7 +86,6 @@ Devices: [Quanser Consulting] MultiQ-3 (multiq3)
 struct multiq3_private {
 	unsigned int ao_readback[2];
 };
-#define devpriv ((struct multiq3_private *)dev->private)
 
 static int multiq3_ai_insn_read(struct comedi_device *dev,
 				struct comedi_subdevice *s,
@@ -129,6 +128,7 @@ static int multiq3_ao_insn_read(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct multiq3_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -142,6 +142,7 @@ static int multiq3_ao_insn_write(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct multiq3_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -228,6 +229,7 @@ static void encoder_reset(struct comedi_device *dev)
 static int multiq3_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	struct multiq3_private *devpriv;
 	int result = 0;
 	unsigned long iobase;
 	unsigned int irq;
@@ -254,9 +256,10 @@ static int multiq3_attach(struct comedi_device *dev,
 	if (result)
 		return result;
 
-	result = alloc_private(dev, sizeof(struct multiq3_private));
+	result = alloc_private(dev, sizeof(*devpriv));
 	if (result < 0)
 		return result;
+	devpriv = dev->private;
 
 	s = dev->subdevices + 0;
 	/* ai subdevice */
diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index a80c52f..deaf528 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -104,7 +104,6 @@ static const struct ni6527_board ni6527_boards[] = {
 };
 
 #define n_ni6527_boards ARRAY_SIZE(ni6527_boards)
-#define this_board ((const struct ni6527_board *)dev->board_ptr)
 
 static DEFINE_PCI_DEVICE_TABLE(ni6527_pci_table) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2b10)},
@@ -120,14 +119,13 @@ struct ni6527_private {
 	unsigned int filter_enable;
 };
 
-#define devpriv ((struct ni6527_private *)dev->private)
-
 static int ni6527_find_device(struct comedi_device *dev, int bus, int slot);
 
 static int ni6527_di_insn_config(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct ni6527_private *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 	unsigned int interval;
 
@@ -174,6 +172,8 @@ static int ni6527_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct ni6527_private *devpriv = dev->private;
+
 	data[1] = readb(devpriv->mite->daq_io_addr + Port_Register(0));
 	data[1] |= readb(devpriv->mite->daq_io_addr + Port_Register(1)) << 8;
 	data[1] |= readb(devpriv->mite->daq_io_addr + Port_Register(2)) << 16;
@@ -185,6 +185,8 @@ static int ni6527_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct ni6527_private *devpriv = dev->private;
+
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
@@ -212,6 +214,7 @@ static int ni6527_do_insn_bits(struct comedi_device *dev,
 static irqreturn_t ni6527_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct ni6527_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 2;
 	unsigned int status;
 
@@ -311,6 +314,7 @@ static int ni6527_intr_cmdtest(struct comedi_device *dev,
 static int ni6527_intr_cmd(struct comedi_device *dev,
 			   struct comedi_subdevice *s)
 {
+	struct ni6527_private *devpriv = dev->private;
 	/* struct comedi_cmd *cmd = &s->async->cmd; */
 
 	writeb(ClrEdge | ClrOverflow,
@@ -325,6 +329,8 @@ static int ni6527_intr_cmd(struct comedi_device *dev,
 static int ni6527_intr_cancel(struct comedi_device *dev,
 			      struct comedi_subdevice *s)
 {
+	struct ni6527_private *devpriv = dev->private;
+
 	writeb(0x00, devpriv->mite->daq_io_addr + Master_Interrupt_Control);
 
 	return 0;
@@ -342,6 +348,8 @@ static int ni6527_intr_insn_config(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn, unsigned int *data)
 {
+	struct ni6527_private *devpriv = dev->private;
+
 	if (insn->n < 1)
 		return -EINVAL;
 	if (data[0] != INSN_CONFIG_CHANGE_NOTIFY)
@@ -366,18 +374,22 @@ static int ni6527_intr_insn_config(struct comedi_device *dev,
 
 static int ni6527_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct ni6527_board *this_board;
+	struct ni6527_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
 
 	printk(KERN_INFO "comedi%d: ni6527\n", dev->minor);
 
-	ret = alloc_private(dev, sizeof(struct ni6527_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	ret = ni6527_find_device(dev, it->options[0], it->options[1]);
 	if (ret < 0)
 		return ret;
+	this_board = comedi_board(dev);
 
 	ret = mite_setup(devpriv->mite);
 	if (ret < 0) {
@@ -443,6 +455,8 @@ static int ni6527_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void ni6527_detach(struct comedi_device *dev)
 {
+	struct ni6527_private *devpriv = dev->private;
+
 	if (devpriv && devpriv->mite && devpriv->mite->daq_io_addr)
 		writeb(0x00,
 		       devpriv->mite->daq_io_addr + Master_Interrupt_Control);
@@ -454,6 +468,7 @@ static void ni6527_detach(struct comedi_device *dev)
 
 static int ni6527_find_device(struct comedi_device *dev, int bus, int slot)
 {
+	struct ni6527_private *devpriv = dev->private;
 	struct mite_struct *mite;
 	int i;
 
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index b53a428..fd96c4b 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -154,11 +154,6 @@ static const struct a2150_board a2150_boards[] = {
 	 },
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct a2150_board *)dev->board_ptr)
-
 struct a2150_private {
 
 	volatile unsigned int count;	/* number of data points left to be taken */
@@ -169,8 +164,6 @@ struct a2150_private {
 	int config_bits;	/*  config register bits */
 };
 
-#define devpriv ((struct a2150_private *)dev->private)
-
 static int a2150_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
 
 static int a2150_get_timing(struct comedi_device *dev, unsigned int *period,
@@ -182,6 +175,8 @@ static int a2150_set_chanlist(struct comedi_device *dev,
 
 static void ni_dump_regs(struct comedi_device *dev)
 {
+	struct a2150_private *devpriv = dev->private;
+
 	printk("config bits 0x%x\n", devpriv->config_bits);
 	printk("irq dma bits 0x%x\n", devpriv->irq_dma_bits);
 	printk("status bits 0x%x\n", inw(dev->iobase + STATUS_REG));
@@ -196,6 +191,7 @@ static irqreturn_t a2150_interrupt(int irq, void *d)
 	int status;
 	unsigned long flags;
 	struct comedi_device *dev = d;
+	struct a2150_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct comedi_async *async;
 	struct comedi_cmd *cmd;
@@ -300,6 +296,8 @@ static irqreturn_t a2150_interrupt(int irq, void *d)
 
 static int a2150_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct a2150_private *devpriv = dev->private;
+
 	/*  disable dma on card */
 	devpriv->irq_dma_bits &= ~DMA_INTR_EN_BIT & ~DMA_EN_BIT;
 	outw(devpriv->irq_dma_bits, dev->iobase + IRQ_DMA_CNTRL_REG);
@@ -316,6 +314,7 @@ static int a2150_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 static int a2150_ai_cmdtest(struct comedi_device *dev,
 			    struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
+	const struct a2150_board *thisboard = comedi_board(dev);
 	int err = 0;
 	int tmp;
 	int startChan;
@@ -447,6 +446,7 @@ static int a2150_ai_cmdtest(struct comedi_device *dev,
 
 static int a2150_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct a2150_private *devpriv = dev->private;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
 	unsigned long lock_flags;
@@ -558,6 +558,7 @@ static int a2150_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 static int a2150_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	struct a2150_private *devpriv = dev->private;
 	unsigned int i, n;
 	static const int timeout = 100000;
 	static const int filter_delay = 36;
@@ -637,6 +638,8 @@ static int a2150_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int a2150_get_timing(struct comedi_device *dev, unsigned int *period,
 			    int flags)
 {
+	const struct a2150_board *thisboard = comedi_board(dev);
+	struct a2150_private *devpriv = dev->private;
 	int lub, glb, temp;
 	int lub_divisor_shift, lub_index, glb_divisor_shift, glb_index;
 	int i, j;
@@ -711,6 +714,8 @@ static int a2150_set_chanlist(struct comedi_device *dev,
 			      unsigned int start_channel,
 			      unsigned int num_channels)
 {
+	struct a2150_private *devpriv = dev->private;
+
 	if (start_channel + num_channels > 4)
 		return -1;
 
@@ -749,6 +754,8 @@ static int a2150_probe(struct comedi_device *dev)
 
 static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct a2150_board *thisboard;
+	struct a2150_private *devpriv;
 	struct comedi_subdevice *s;
 	unsigned long iobase = it->options[0];
 	unsigned int irq = it->options[1];
@@ -772,8 +779,9 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk("\n");
 
 	/* allocate and initialize dev->private */
-	if (alloc_private(dev, sizeof(struct a2150_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	if (iobase == 0) {
 		printk(" io base address required\n");
@@ -825,6 +833,7 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	dev->board_ptr = a2150_boards + a2150_probe(dev);
+	thisboard = comedi_board(dev);
 	dev->board_name = thisboard->name;
 
 	ret = comedi_alloc_subdevices(dev, 1);
@@ -877,6 +886,8 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void a2150_detach(struct comedi_device *dev)
 {
+	struct a2150_private *devpriv = dev->private;
+
 	if (dev->iobase) {
 		outw(APD_BIT | DPD_BIT, dev->iobase + CONFIG_REG);
 		release_region(dev->iobase, A2150_SIZE);
diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index 62c8c44..366c98d 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -167,10 +167,10 @@ struct atao_private {
 	unsigned int ao_readback[10];
 };
 
-#define devpriv ((struct atao_private *)dev->private)
-
 static void atao_reset(struct comedi_device *dev)
 {
+	struct atao_private *devpriv = dev->private;
+
 	/* This is the reset sequence described in the manual */
 
 	devpriv->cfg1 = 0;
@@ -202,6 +202,7 @@ static void atao_reset(struct comedi_device *dev)
 static int atao_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			 struct comedi_insn *insn, unsigned int *data)
 {
+	struct atao_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 	short bits;
@@ -226,6 +227,7 @@ static int atao_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int atao_ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			 struct comedi_insn *insn, unsigned int *data)
 {
+	struct atao_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -254,6 +256,7 @@ static int atao_dio_insn_config(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct atao_private *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 	unsigned int mask, bit;
 
@@ -309,6 +312,7 @@ static int atao_calib_insn_write(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct atao_private *devpriv = dev->private;
 	unsigned int bitstring, bit;
 	unsigned int chan = CR_CHAN(insn->chanspec);
 
@@ -331,6 +335,7 @@ static int atao_calib_insn_write(struct comedi_device *dev,
 static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct atao_board *board = comedi_board(dev);
+	struct atao_private *devpriv;
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	int ao_unipolar;
@@ -351,8 +356,9 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = board->name;
 
-	if (alloc_private(dev, sizeof(struct atao_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret)
diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 2c78d3d..d877388 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -101,7 +101,6 @@ Devices: [National Instruments] AT-MIO-16 (atmio16), AT-MIO-16D (atmio16d)
 #define CLOCK_100_HZ	0x8F25
 /* Other miscellaneous defines */
 #define ATMIO16D_SIZE	32	/* bus address range */
-#define devpriv ((struct atmio16d_private *)dev->private)
 #define ATMIO16D_TIMEOUT 10
 
 struct atmio16_board_t {
@@ -201,6 +200,7 @@ static void reset_counters(struct comedi_device *dev)
 
 static void reset_atmio16d(struct comedi_device *dev)
 {
+	struct atmio16d_private *devpriv = dev->private;
 	int i;
 
 	/* now we need to initialize the board */
@@ -345,6 +345,7 @@ static int atmio16d_ai_cmdtest(struct comedi_device *dev,
 static int atmio16d_ai_cmd(struct comedi_device *dev,
 			   struct comedi_subdevice *s)
 {
+	struct atmio16d_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	unsigned int timer, base_clock;
 	unsigned int sample_count, tmp, chan, gain;
@@ -504,6 +505,7 @@ static int atmio16d_ai_insn_read(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct atmio16d_private *devpriv = dev->private;
 	int i, t;
 	int chan;
 	int gain;
@@ -557,6 +559,7 @@ static int atmio16d_ao_insn_read(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct atmio16d_private *devpriv = dev->private;
 	int i;
 
 	for (i = 0; i < insn->n; i++)
@@ -568,6 +571,7 @@ static int atmio16d_ao_insn_write(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct atmio16d_private *devpriv = dev->private;
 	int i;
 	int chan;
 	int d;
@@ -614,6 +618,7 @@ static int atmio16d_dio_insn_config(struct comedi_device *dev,
 				    struct comedi_insn *insn,
 				    unsigned int *data)
 {
+	struct atmio16d_private *devpriv = dev->private;
 	int i;
 	int mask;
 
@@ -669,6 +674,7 @@ static int atmio16d_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
 	const struct atmio16_board_t *board = comedi_board(dev);
+	struct atmio16d_private *devpriv;
 	unsigned int irq;
 	unsigned long iobase;
 	int ret;
@@ -690,9 +696,10 @@ static int atmio16d_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	ret = alloc_private(dev, sizeof(struct atmio16d_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	/* reset the atmio16d hardware */
 	reset_atmio16d(dev);
diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index e27cae0..65eb92c 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -86,18 +86,6 @@ static const struct dio24_board_struct dio24_boards[] = {
 	 },
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct dio24_board_struct *)dev->board_ptr)
-
-struct dio24_private {
-
-	int data;		/* number of data points left to be taken */
-};
-
-#define devpriv ((struct dio24_private *)dev->private)
-
 static struct comedi_driver driver_dio24 = {
 	.driver_name = "ni_daq_dio24",
 	.module = THIS_MODULE,
@@ -110,6 +98,7 @@ static struct comedi_driver driver_dio24 = {
 
 static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct dio24_board_struct *thisboard = comedi_board(dev);
 	struct comedi_subdevice *s;
 	unsigned long iobase = 0;
 #ifdef incomplete
@@ -118,10 +107,6 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct pcmcia_device *link;
 	int ret;
 
-	/* allocate and initialize dev->private */
-	if (alloc_private(dev, sizeof(struct dio24_private)) < 0)
-		return -ENOMEM;
-
 	/*  get base address, irq etc. based on bustype */
 	switch (thisboard->bustype) {
 	case pcmcia_bustype:
@@ -172,6 +157,8 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void dio24_detach(struct comedi_device *dev)
 {
+	const struct dio24_board_struct *thisboard = comedi_board(dev);
+
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 0);
 	if (thisboard->bustype != pcmcia_bustype && dev->iobase)
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index ab8b787..263d4e5 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -483,18 +483,11 @@ static const struct labpc_board_struct labpc_boards[] = {
 #endif
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((struct labpc_board_struct *)dev->board_ptr)
-
 /* size in bytes of dma buffer */
 static const int dma_buffer_size = 0xff00;
 /* 2 bytes per sample */
 static const int sample_size = 2;
 
-#define devpriv ((struct labpc_private *)dev->private)
-
 static struct comedi_driver driver_labpc = {
 	.driver_name = DRV_NAME,
 	.module = THIS_MODULE,
@@ -519,6 +512,8 @@ static inline int labpc_counter_load(struct comedi_device *dev,
 				     unsigned int counter_number,
 				     unsigned int count, unsigned int mode)
 {
+	const struct labpc_board_struct *thisboard = comedi_board(dev);
+
 	if (thisboard->memory_mapped_io)
 		return i8254_mm_load((void *)base_address, 0, counter_number,
 				     count, mode);
@@ -529,6 +524,8 @@ static inline int labpc_counter_load(struct comedi_device *dev,
 int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 			unsigned int irq, unsigned int dma_chan)
 {
+	const struct labpc_board_struct *thisboard = comedi_board(dev);
+	struct labpc_private *devpriv = dev->private;
 	struct comedi_subdevice *s;
 	int i;
 	unsigned long isr_flags;
@@ -721,6 +718,8 @@ EXPORT_SYMBOL_GPL(labpc_common_attach);
 
 static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct labpc_board_struct *thisboard = comedi_board(dev);
+	struct labpc_private *devpriv;
 	unsigned long iobase = 0;
 	unsigned int irq = 0;
 	unsigned int dma_chan = 0;
@@ -729,8 +728,9 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif
 
 	/* allocate and initialize dev->private */
-	if (alloc_private(dev, sizeof(struct labpc_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	/* get base address, irq etc. based on bustype */
 	switch (thisboard->bustype) {
@@ -779,8 +779,10 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #ifdef CONFIG_COMEDI_PCI_DRIVERS
 static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
 {
+	struct labpc_private *devpriv = dev->private;
 	struct mite_struct *mite;
 	int i;
+
 	for (mite = mite_devices; mite; mite = mite->next) {
 		if (mite->used)
 			continue;
@@ -809,6 +811,9 @@ static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
 
 void labpc_common_detach(struct comedi_device *dev)
 {
+	const struct labpc_board_struct *thisboard = comedi_board(dev);
+	struct labpc_private *devpriv = dev->private;
+
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 #ifdef CONFIG_ISA_DMA_API
@@ -830,6 +835,8 @@ EXPORT_SYMBOL_GPL(labpc_common_detach);
 
 static void labpc_clear_adc_fifo(const struct comedi_device *dev)
 {
+	struct labpc_private *devpriv = dev->private;
+
 	devpriv->write_byte(0x1, dev->iobase + ADC_CLEAR_REG);
 	devpriv->read_byte(dev->iobase + ADC_FIFO_REG);
 	devpriv->read_byte(dev->iobase + ADC_FIFO_REG);
@@ -837,6 +844,7 @@ static void labpc_clear_adc_fifo(const struct comedi_device *dev)
 
 static int labpc_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct labpc_private *devpriv = dev->private;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->spinlock, flags);
@@ -1009,6 +1017,7 @@ static void labpc_set_ai_scan_period(struct comedi_cmd *cmd, unsigned int ns)
 static int labpc_ai_cmdtest(struct comedi_device *dev,
 			    struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
+	const struct labpc_board_struct *thisboard = comedi_board(dev);
 	int err = 0;
 	int tmp, tmp2;
 	int stop_mask;
@@ -1148,6 +1157,8 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 
 static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	const struct labpc_board_struct *thisboard = comedi_board(dev);
+	struct labpc_private *devpriv = dev->private;
 	int channel, range, aref;
 #ifdef CONFIG_ISA_DMA_API
 	unsigned long irq_flags;
@@ -1414,6 +1425,8 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 static irqreturn_t labpc_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	const struct labpc_board_struct *thisboard = comedi_board(dev);
+	struct labpc_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct comedi_async *async;
 	struct comedi_cmd *cmd;
@@ -1502,6 +1515,7 @@ static irqreturn_t labpc_interrupt(int irq, void *d)
 /* read all available samples from ai fifo */
 static int labpc_drain_fifo(struct comedi_device *dev)
 {
+	struct labpc_private *devpriv = dev->private;
 	unsigned int lsb, msb;
 	short data;
 	struct comedi_async *async = dev->read_subdev->async;
@@ -1537,6 +1551,7 @@ static int labpc_drain_fifo(struct comedi_device *dev)
 #ifdef CONFIG_ISA_DMA_API
 static void labpc_drain_dma(struct comedi_device *dev)
 {
+	struct labpc_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct comedi_async *async = s->async;
 	int status;
@@ -1590,6 +1605,8 @@ static void labpc_drain_dma(struct comedi_device *dev)
 
 static void handle_isa_dma(struct comedi_device *dev)
 {
+	struct labpc_private *devpriv = dev->private;
+
 	labpc_drain_dma(dev);
 
 	enable_dma(devpriv->dma_chan);
@@ -1604,6 +1621,8 @@ static void handle_isa_dma(struct comedi_device *dev)
 static void labpc_drain_dregs(struct comedi_device *dev)
 {
 #ifdef CONFIG_ISA_DMA_API
+	struct labpc_private *devpriv = dev->private;
+
 	if (devpriv->current_transfer == isa_dma_transfer)
 		labpc_drain_dma(dev);
 #endif
@@ -1614,6 +1633,8 @@ static void labpc_drain_dregs(struct comedi_device *dev)
 static int labpc_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	const struct labpc_board_struct *thisboard = comedi_board(dev);
+	struct labpc_private *devpriv = dev->private;
 	int i, n;
 	int chan, range;
 	int lsb, msb;
@@ -1703,6 +1724,8 @@ static int labpc_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int labpc_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	const struct labpc_board_struct *thisboard = comedi_board(dev);
+	struct labpc_private *devpriv = dev->private;
 	int channel, range;
 	unsigned long flags;
 	int lsb, msb;
@@ -1744,6 +1767,8 @@ static int labpc_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int labpc_ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	struct labpc_private *devpriv = dev->private;
+
 	data[0] = devpriv->ao_value[CR_CHAN(insn->chanspec)];
 
 	return 1;
@@ -1753,6 +1778,8 @@ static int labpc_calib_read_insn(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct labpc_private *devpriv = dev->private;
+
 	data[0] = devpriv->caldac[CR_CHAN(insn->chanspec)];
 
 	return 1;
@@ -1772,6 +1799,8 @@ static int labpc_eeprom_read_insn(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct labpc_private *devpriv = dev->private;
+
 	data[0] = devpriv->eeprom_data[CR_CHAN(insn->chanspec)];
 
 	return 1;
@@ -1827,6 +1856,7 @@ static unsigned int labpc_suggest_transfer_size(struct comedi_cmd cmd)
 /* figures out what counter values to use based on command */
 static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
 {
+	struct labpc_private *devpriv = dev->private;
 	/* max value for 16 bit counter in mode 2 */
 	const int max_counter_value = 0x10000;
 	/* min value for 16 bit counter in mode 2 */
@@ -1941,6 +1971,7 @@ static int labpc_dio_mem_callback(int dir, int port, int data,
 static void labpc_serial_out(struct comedi_device *dev, unsigned int value,
 			     unsigned int value_width)
 {
+	struct labpc_private *devpriv = dev->private;
 	int i;
 
 	for (i = 1; i <= value_width; i++) {
@@ -1965,6 +1996,7 @@ static void labpc_serial_out(struct comedi_device *dev, unsigned int value,
 /* lowlevel read from eeprom */
 static unsigned int labpc_serial_in(struct comedi_device *dev)
 {
+	struct labpc_private *devpriv = dev->private;
 	unsigned int value = 0;
 	int i;
 	const int value_width = 8;	/*  number of bits wide values are */
@@ -1994,6 +2026,7 @@ static unsigned int labpc_serial_in(struct comedi_device *dev)
 static unsigned int labpc_eeprom_read(struct comedi_device *dev,
 				      unsigned int address)
 {
+	struct labpc_private *devpriv = dev->private;
 	unsigned int value;
 	/*  bits to tell eeprom to expect a read */
 	const int read_instruction = 0x3;
@@ -2026,6 +2059,7 @@ static unsigned int labpc_eeprom_read(struct comedi_device *dev,
 static int labpc_eeprom_write(struct comedi_device *dev,
 				unsigned int address, unsigned int value)
 {
+	struct labpc_private *devpriv = dev->private;
 	const int write_enable_instruction = 0x6;
 	const int write_instruction = 0x2;
 	const int write_length = 8;	/*  8 bit write lengths to eeprom */
@@ -2083,6 +2117,7 @@ static int labpc_eeprom_write(struct comedi_device *dev,
 
 static unsigned int labpc_eeprom_read_status(struct comedi_device *dev)
 {
+	struct labpc_private *devpriv = dev->private;
 	unsigned int value;
 	const int read_status_instruction = 0x5;
 	const int write_length = 8;	/*  8 bit write lengths to eeprom */
@@ -2112,6 +2147,8 @@ static unsigned int labpc_eeprom_read_status(struct comedi_device *dev)
 static void write_caldac(struct comedi_device *dev, unsigned int channel,
 			 unsigned int value)
 {
+	struct labpc_private *devpriv = dev->private;
+
 	if (value == devpriv->caldac[channel])
 		return;
 	devpriv->caldac[channel] = value;
diff --git a/drivers/staging/comedi/drivers/ni_labpc_cs.c b/drivers/staging/comedi/drivers/ni_labpc_cs.c
index dbb61b6..97e0a45 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_cs.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_cs.c
@@ -110,11 +110,6 @@ static const struct labpc_board_struct labpc_cs_boards[] = {
 	 },
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct labpc_board_struct *)dev->board_ptr)
-
 static struct comedi_driver driver_labpc_cs = {
 	.driver_name = "ni_labpc_cs",
 	.module = THIS_MODULE,
@@ -127,13 +122,16 @@ static struct comedi_driver driver_labpc_cs = {
 
 static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct labpc_board_struct *thisboard = comedi_board(dev);
+	struct labpc_private *devpriv;
 	unsigned long iobase = 0;
 	unsigned int irq = 0;
 	struct pcmcia_device *link;
 
 	/* allocate and initialize dev->private */
-	if (alloc_private(dev, sizeof(struct labpc_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	/*  get base address, irq etc. based on bustype */
 	switch (thisboard->bustype) {
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index 0a55de9..3a9152c 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -370,7 +370,6 @@ static const struct nidio_board nidio_boards[] = {
 };
 
 #define n_nidio_boards ARRAY_SIZE(nidio_boards)
-#define this_board ((const struct nidio_board *)dev->board_ptr)
 
 struct nidio96_private {
 	struct mite_struct *mite;
@@ -381,7 +380,6 @@ struct nidio96_private {
 	struct mite_dma_descriptor_ring *di_mite_ring;
 	spinlock_t mite_channel_lock;
 };
-#define devpriv ((struct nidio96_private *)dev->private)
 
 static int ni_pcidio_cmdtest(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
@@ -403,6 +401,7 @@ static void ni_pcidio_print_status(unsigned int status);
 
 static int ni_pcidio_request_di_mite_channel(struct comedi_device *dev)
 {
+	struct nidio96_private *devpriv = dev->private;
 	unsigned long flags;
 
 	spin_lock_irqsave(&devpriv->mite_channel_lock, flags);
@@ -426,6 +425,7 @@ static int ni_pcidio_request_di_mite_channel(struct comedi_device *dev)
 
 static void ni_pcidio_release_di_mite_channel(struct comedi_device *dev)
 {
+	struct nidio96_private *devpriv = dev->private;
 	unsigned long flags;
 
 	spin_lock_irqsave(&devpriv->mite_channel_lock, flags);
@@ -464,6 +464,7 @@ void ni_pcidio_event(struct comedi_device *dev, struct comedi_subdevice *s)
 
 static int ni_pcidio_poll(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct nidio96_private *devpriv = dev->private;
 	unsigned long irq_flags;
 	int count;
 
@@ -480,6 +481,7 @@ static int ni_pcidio_poll(struct comedi_device *dev, struct comedi_subdevice *s)
 static irqreturn_t nidio_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct nidio96_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices;
 	struct comedi_async *async = s->async;
 	struct mite_struct *mite = devpriv->mite;
@@ -686,6 +688,7 @@ static void ni_pcidio_print_status(unsigned int flags)
 #ifdef unused
 static void debug_int(struct comedi_device *dev)
 {
+	struct nidio96_private *devpriv = dev->private;
 	int a, b;
 	static int n_int;
 	struct timeval tv;
@@ -717,6 +720,8 @@ static int ni_pcidio_insn_config(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct nidio96_private *devpriv = dev->private;
+
 	if (insn->n != 1)
 		return -EINVAL;
 	switch (data[0]) {
@@ -745,6 +750,8 @@ static int ni_pcidio_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct nidio96_private *devpriv = dev->private;
+
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
@@ -890,6 +897,7 @@ static int ni_pcidio_ns_to_timer(int *nanosec, int round_mode)
 
 static int ni_pcidio_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct nidio96_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
 	/* XXX configure ports for input */
@@ -1007,6 +1015,7 @@ static int ni_pcidio_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 static int setup_mite_dma(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct nidio96_private *devpriv = dev->private;
 	int retval;
 	unsigned long flags;
 
@@ -1031,6 +1040,8 @@ static int setup_mite_dma(struct comedi_device *dev, struct comedi_subdevice *s)
 static int ni_pcidio_inttrig(struct comedi_device *dev,
 			     struct comedi_subdevice *s, unsigned int trignum)
 {
+	struct nidio96_private *devpriv = dev->private;
+
 	if (trignum != 0)
 		return -EINVAL;
 
@@ -1043,6 +1054,8 @@ static int ni_pcidio_inttrig(struct comedi_device *dev,
 static int ni_pcidio_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	struct nidio96_private *devpriv = dev->private;
+
 	writeb(0x00,
 	       devpriv->mite->daq_io_addr + Master_DMA_And_Interrupt_Control);
 	ni_pcidio_release_di_mite_channel(dev);
@@ -1053,6 +1066,7 @@ static int ni_pcidio_cancel(struct comedi_device *dev,
 static int ni_pcidio_change(struct comedi_device *dev,
 			    struct comedi_subdevice *s, unsigned long new_size)
 {
+	struct nidio96_private *devpriv = dev->private;
 	int ret;
 
 	ret = mite_buf_change(devpriv->di_mite_ring, s->async);
@@ -1067,8 +1081,10 @@ static int ni_pcidio_change(struct comedi_device *dev,
 static int pci_6534_load_fpga(struct comedi_device *dev, int fpga_index,
 			      u8 *data, int data_len)
 {
+	struct nidio96_private *devpriv = dev->private;
 	static const int timeout = 1000;
 	int i, j;
+
 	writew(0x80 | fpga_index,
 	       devpriv->mite->daq_io_addr + Firmware_Control_Register);
 	writew(0xc0 | fpga_index,
@@ -1125,8 +1141,10 @@ static int pci_6534_reset_fpga(struct comedi_device *dev, int fpga_index)
 
 static int pci_6534_reset_fpgas(struct comedi_device *dev)
 {
+	struct nidio96_private *devpriv = dev->private;
 	int ret;
 	int i;
+
 	writew(0x0, devpriv->mite->daq_io_addr + Firmware_Control_Register);
 	for (i = 0; i < 3; ++i) {
 		ret = pci_6534_reset_fpga(dev, i);
@@ -1139,6 +1157,8 @@ static int pci_6534_reset_fpgas(struct comedi_device *dev)
 
 static void pci_6534_init_main_fpga(struct comedi_device *dev)
 {
+	struct nidio96_private *devpriv = dev->private;
+
 	writel(0, devpriv->mite->daq_io_addr + FPGA_Control1_Register);
 	writel(0, devpriv->mite->daq_io_addr + FPGA_Control2_Register);
 	writel(0, devpriv->mite->daq_io_addr + FPGA_SCALS_Counter_Register);
@@ -1179,6 +1199,7 @@ static int pci_6534_upload_firmware(struct comedi_device *dev, int options[])
 
 static int nidio_find_device(struct comedi_device *dev, int bus, int slot)
 {
+	struct nidio96_private *devpriv = dev->private;
 	struct mite_struct *mite;
 	int i;
 
@@ -1206,6 +1227,8 @@ static int nidio_find_device(struct comedi_device *dev, int bus, int slot)
 
 static int nidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct nidio_board *this_board;
+	struct nidio96_private *devpriv;
 	struct comedi_subdevice *s;
 	int i;
 	int ret;
@@ -1214,14 +1237,17 @@ static int nidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	printk(KERN_INFO "comedi%d: nidio:", dev->minor);
 
-	ret = alloc_private(dev, sizeof(struct nidio96_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
+
 	spin_lock_init(&devpriv->mite_channel_lock);
 
 	ret = nidio_find_device(dev, it->options[0], it->options[1]);
 	if (ret < 0)
 		return ret;
+	this_board = comedi_board(dev);
 
 	ret = mite_setup(devpriv->mite);
 	if (ret < 0) {
@@ -1307,6 +1333,8 @@ static int nidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void nidio_detach(struct comedi_device *dev)
 {
+	const struct nidio_board *this_board = comedi_board(dev);
+	struct nidio96_private *devpriv = dev->private;
 	int i;
 
 	if (this_board && !this_board->is_diodaq) {
diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index 89f4d43..3974c0d 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1593,7 +1593,7 @@ static int pcimio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	int ret;
 
-	dev_info(dev->class_dev, "ni_pcimio: attach\n");
+	dev_info(dev->hw_dev, "comedi%d: ni_pcimio:\n", dev->minor);
 
 	ret = ni_alloc_private(dev);
 	if (ret < 0)
@@ -1603,7 +1603,7 @@ static int pcimio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 
-	dev_dbg(dev->class_dev, "%s\n", boardtype.name);
+	dev_dbg(dev->hw_dev, "%s\n", boardtype.name);
 	dev->board_name = boardtype.name;
 
 	if (boardtype.reg_type & ni_reg_m_series_mask) {
diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index bb72d0b..d50adcd 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -160,14 +160,13 @@ struct pcl711_private {
 	unsigned int divisor2;
 };
 
-#define devpriv ((struct pcl711_private *)dev->private)
-
 static irqreturn_t pcl711_interrupt(int irq, void *d)
 {
 	int lo, hi;
 	int data;
 	struct comedi_device *dev = d;
 	const struct pcl711_board *board = comedi_board(dev);
+	struct pcl711_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 
 	if (!dev->attached) {
@@ -263,6 +262,7 @@ ok:
 static int pcl711_ai_cmdtest(struct comedi_device *dev,
 			     struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
+	struct pcl711_private *devpriv = dev->private;
 	int tmp;
 	int err = 0;
 
@@ -366,6 +366,7 @@ static int pcl711_ai_cmdtest(struct comedi_device *dev,
 
 static int pcl711_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct pcl711_private *devpriv = dev->private;
 	int timer1, timer2;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
@@ -415,6 +416,7 @@ static int pcl711_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 static int pcl711_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcl711_private *devpriv = dev->private;
 	int n;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -434,6 +436,7 @@ static int pcl711_ao_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcl711_private *devpriv = dev->private;
 	int n;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -477,6 +480,7 @@ static int pcl711_do_insn_bits(struct comedi_device *dev,
 static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct pcl711_board *board = comedi_board(dev);
+	struct pcl711_private *devpriv;
 	int ret;
 	unsigned long iobase;
 	unsigned int irq;
@@ -516,9 +520,10 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	ret = alloc_private(dev, sizeof(struct pcl711_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	s = dev->subdevices + 0;
 	/* AI subdevice */
diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index 2b10f1d..b4a4b31 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -152,11 +152,10 @@ struct pcl726_private {
 	unsigned int ao_readback[12];
 };
 
-#define devpriv ((struct pcl726_private *)dev->private)
-
 static int pcl726_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcl726_private *devpriv = dev->private;
 	int hi, lo;
 	int n;
 	int chan = CR_CHAN(insn->chanspec);
@@ -183,6 +182,7 @@ static int pcl726_ao_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcl726_private *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 	int n;
 
@@ -226,6 +226,7 @@ static int pcl726_do_insn_bits(struct comedi_device *dev,
 static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct pcl726_board *board = comedi_board(dev);
+	struct pcl726_private *devpriv;
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	unsigned int iorange;
@@ -247,9 +248,10 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = board->name;
 
-	ret = alloc_private(dev, sizeof(struct pcl726_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	for (i = 0; i < 12; i++) {
 		devpriv->bipolar[i] = 0;
diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 578fd89..907fd92 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -368,8 +368,6 @@ struct pcl812_private {
 	unsigned int ao_readback[2];	/*  data for AO readback */
 };
 
-#define devpriv ((struct pcl812_private *)dev->private)
-
 /*
 ==============================================================================
 */
@@ -387,6 +385,7 @@ static int pcl812_ai_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcl812_private *devpriv = dev->private;
 	int n;
 	int timeout, hi;
 
@@ -464,6 +463,7 @@ static int pcl812_ao_insn_write(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcl812_private *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 	int i;
 
@@ -485,6 +485,7 @@ static int pcl812_ao_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcl812_private *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 	int i;
 
@@ -532,6 +533,7 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
 			     struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
 	const struct pcl812_board *board = comedi_board(dev);
+	struct pcl812_private *devpriv = dev->private;
 	int err = 0;
 	int tmp, divisor1, divisor2;
 
@@ -656,6 +658,7 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
 static int pcl812_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	const struct pcl812_board *board = comedi_board(dev);
+	struct pcl812_private *devpriv = dev->private;
 	unsigned int divisor1 = 0, divisor2 = 0, i, dma_flags, bytes;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
@@ -806,6 +809,7 @@ static irqreturn_t interrupt_pcl812_ai_int(int irq, void *d)
 	char err = 1;
 	unsigned int mask, timeout;
 	struct comedi_device *dev = d;
+	struct pcl812_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	unsigned int next_chan;
 
@@ -879,6 +883,7 @@ static void transfer_from_dma_buf(struct comedi_device *dev,
 				  struct comedi_subdevice *s, short *ptr,
 				  unsigned int bufptr, unsigned int len)
 {
+	struct pcl812_private *devpriv = dev->private;
 	unsigned int i;
 
 	s->async->events = 0;
@@ -909,6 +914,7 @@ static void transfer_from_dma_buf(struct comedi_device *dev,
 static irqreturn_t interrupt_pcl812_ai_dma(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct pcl812_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	unsigned long dma_flags;
 	int len, bufptr;
@@ -955,6 +961,7 @@ static irqreturn_t interrupt_pcl812_ai_dma(int irq, void *d)
 static irqreturn_t interrupt_pcl812(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct pcl812_private *devpriv = dev->private;
 
 	if (!dev->attached) {
 		comedi_error(dev, "spurious interrupt");
@@ -971,6 +978,7 @@ static irqreturn_t interrupt_pcl812(int irq, void *d)
 */
 static int pcl812_ai_poll(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct pcl812_private *devpriv = dev->private;
 	unsigned long flags;
 	unsigned int top1, top2, i;
 
@@ -1019,6 +1027,7 @@ static void setup_range_channel(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				unsigned int rangechan, char wait)
 {
+	struct pcl812_private *devpriv = dev->private;
 	unsigned char chan_reg = CR_CHAN(rangechan);	/*  normal board */
 							/*  gain index */
 	unsigned char gain_reg = CR_RANGE(rangechan) +
@@ -1080,8 +1089,9 @@ static void start_pacer(struct comedi_device *dev, int mode,
 static void free_resources(struct comedi_device *dev)
 {
 	const struct pcl812_board *board = comedi_board(dev);
+	struct pcl812_private *devpriv = dev->private;
 
-	if (dev->private) {
+	if (devpriv) {
 		if (devpriv->dmabuf[0])
 			free_pages(devpriv->dmabuf[0], devpriv->dmapages[0]);
 		if (devpriv->dmabuf[1])
@@ -1101,6 +1111,8 @@ static void free_resources(struct comedi_device *dev)
 static int pcl812_ai_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	struct pcl812_private *devpriv = dev->private;
+
 	if (devpriv->ai_dma)
 		disable_dma(devpriv->dma);
 	outb(0, dev->iobase + PCL812_CLRINT);	/* clear INT request */
@@ -1117,6 +1129,7 @@ static int pcl812_ai_cancel(struct comedi_device *dev,
 static void pcl812_reset(struct comedi_device *dev)
 {
 	const struct pcl812_board *board = comedi_board(dev);
+	struct pcl812_private *devpriv = dev->private;
 
 	outb(0, dev->iobase + PCL812_MUX);
 	outb(0 + devpriv->range_correction, dev->iobase + PCL812_GAIN);
@@ -1152,6 +1165,7 @@ static void pcl812_reset(struct comedi_device *dev)
 static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct pcl812_board *board = comedi_board(dev);
+	struct pcl812_private *devpriv;
 	int ret, subdev;
 	unsigned long iobase;
 	unsigned int irq;
@@ -1170,11 +1184,12 @@ static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	dev->iobase = iobase;
 
-	ret = alloc_private(dev, sizeof(struct pcl812_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0) {
 		free_resources(dev);
 		return ret;	/* Can't alloc mem */
 	}
+	devpriv = dev->private;
 
 	dev->board_name = board->name;
 
diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index ba6911f..ff8666d 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -125,8 +125,6 @@ struct pcl816_board {
 	int i8254_osc_base;	/*  1/frequency of on board oscilator in ns */
 };
 
-#define devpriv ((struct pcl816_private *)dev->private)
-
 #ifdef unused
 static int RTC_lock;	/* RTC lock */
 static int RTC_timer_lock;	/* RTC int lock */
@@ -258,6 +256,7 @@ static int pcl816_ai_insn_read(struct comedi_device *dev,
 static irqreturn_t interrupt_pcl816_ai_mode13_int(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct pcl816_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	int low, hi;
 	int timeout = 50;	/* wait max 50us */
@@ -314,6 +313,7 @@ static void transfer_from_dma_buf(struct comedi_device *dev,
 				  struct comedi_subdevice *s, short *ptr,
 				  unsigned int bufptr, unsigned int len)
 {
+	struct pcl816_private *devpriv = dev->private;
 	int i;
 
 	s->async->events = 0;
@@ -349,6 +349,7 @@ static void transfer_from_dma_buf(struct comedi_device *dev,
 static irqreturn_t interrupt_pcl816_ai_mode13_dma(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct pcl816_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	int len, bufptr, this_dma_buf;
 	unsigned long dma_flags;
@@ -397,6 +398,8 @@ static irqreturn_t interrupt_pcl816_ai_mode13_dma(int irq, void *d)
 static irqreturn_t interrupt_pcl816(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct pcl816_private *devpriv = dev->private;
+
 	DPRINTK("<I>");
 
 	if (!dev->attached) {
@@ -578,6 +581,7 @@ static int pcl816_ai_cmdtest(struct comedi_device *dev,
 static int pcl816_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	const struct pcl816_board *board = comedi_board(dev);
+	struct pcl816_private *devpriv = dev->private;
 	unsigned int divisor1 = 0, divisor2 = 0, dma_flags, bytes, dmairq;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	unsigned int seglen;
@@ -706,6 +710,7 @@ static int pcl816_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 static int pcl816_ai_poll(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct pcl816_private *devpriv = dev->private;
 	unsigned long flags;
 	unsigned int top1, top2, i;
 
@@ -751,6 +756,8 @@ static int pcl816_ai_poll(struct comedi_device *dev, struct comedi_subdevice *s)
 static int pcl816_ai_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	struct pcl816_private *devpriv = dev->private;
+
 /* DEBUG(printk("pcl816_ai_cancel()\n");) */
 
 	if (devpriv->irq_blocked > 0) {
@@ -956,6 +963,7 @@ setup_channel_list(struct comedi_device *dev,
 		   struct comedi_subdevice *s, unsigned int *chanlist,
 		   unsigned int seglen)
 {
+	struct pcl816_private *devpriv = dev->private;
 	unsigned int i;
 
 	devpriv->ai_act_chanlist_len = seglen;
@@ -1015,6 +1023,7 @@ static int set_rtc_irq_bit(unsigned char bit)
 static int pcl816_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct pcl816_board *board = comedi_board(dev);
+	struct pcl816_private *devpriv;
 	int ret;
 	unsigned long iobase;
 	unsigned int irq, dma;
@@ -1039,9 +1048,10 @@ static int pcl816_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -EIO;
 	}
 
-	ret = alloc_private(dev, sizeof(struct pcl816_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;	/* Can't alloc mem */
+	devpriv = dev->private;
 
 	dev->board_name = board->name;
 
@@ -1240,8 +1250,9 @@ case COMEDI_SUBD_DO:
 static void pcl816_detach(struct comedi_device *dev)
 {
 	const struct pcl816_board *board = comedi_board(dev);
+	struct pcl816_private *devpriv = dev->private;
 
-	if (dev->private) {
+	if (devpriv) {
 		pcl816_ai_cancel(dev, devpriv->sub_ai);
 		pcl816_reset(dev);
 		if (devpriv->dma)
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 34169c1..1e4ad6d 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -325,8 +325,6 @@ static const unsigned int muxonechan[] = { 0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0
 	0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff
 };
 
-#define devpriv ((struct pcl818_private *)dev->private)
-
 /*
 ==============================================================================
 */
@@ -405,6 +403,7 @@ static int pcl818_ao_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcl818_private *devpriv = dev->private;
 	int n;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -418,6 +417,7 @@ static int pcl818_ao_insn_write(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcl818_private *devpriv = dev->private;
 	int n;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -477,6 +477,7 @@ static int pcl818_do_insn_bits(struct comedi_device *dev,
 static irqreturn_t interrupt_pcl818_ai_mode13_int(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct pcl818_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	int low;
 	int timeout = 50;	/* wait max 50us */
@@ -536,6 +537,7 @@ conv_finish:
 static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct pcl818_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	int i, len, bufptr;
 	unsigned long flags;
@@ -615,6 +617,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 static irqreturn_t interrupt_pcl818_ai_mode13_dma_rtc(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct pcl818_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	unsigned long tmp;
 	unsigned int top1, top2, i, bufptr;
@@ -720,6 +723,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma_rtc(int irq, void *d)
 static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct pcl818_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	int i, len, lo;
 
@@ -794,6 +798,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 static irqreturn_t interrupt_pcl818(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct pcl818_private *devpriv = dev->private;
 
 	if (!dev->attached) {
 		comedi_error(dev, "premature interrupt");
@@ -860,6 +865,7 @@ static irqreturn_t interrupt_pcl818(int irq, void *d)
 static void pcl818_ai_mode13dma_int(int mode, struct comedi_device *dev,
 				    struct comedi_subdevice *s)
 {
+	struct pcl818_private *devpriv = dev->private;
 	unsigned int flags;
 	unsigned int bytes;
 
@@ -901,6 +907,7 @@ static void pcl818_ai_mode13dma_int(int mode, struct comedi_device *dev,
 static void pcl818_ai_mode13dma_rtc(int mode, struct comedi_device *dev,
 				    struct comedi_subdevice *s)
 {
+	struct pcl818_private *devpriv = dev->private;
 	unsigned int flags;
 	short *pole;
 
@@ -942,6 +949,7 @@ static void pcl818_ai_mode13dma_rtc(int mode, struct comedi_device *dev,
 static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 			      struct comedi_subdevice *s)
 {
+	struct pcl818_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int divisor1 = 0, divisor2 = 0;
 	unsigned int seglen;
@@ -1062,6 +1070,7 @@ static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 static int pcl818_ao_mode13(int mode, struct comedi_device *dev,
 			    struct comedi_subdevice *s, comedi_trig * it)
 {
+	struct pcl818_private *devpriv = dev->private;
 	int divisor1 = 0, divisor2 = 0;
 
 	if (!dev->irq) {
@@ -1221,6 +1230,7 @@ static void setup_channel_list(struct comedi_device *dev,
 			       unsigned int *chanlist, unsigned int n_chan,
 			       unsigned int seglen)
 {
+	struct pcl818_private *devpriv = dev->private;
 	int i;
 
 	devpriv->act_chanlist_len = seglen;
@@ -1258,6 +1268,7 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 		      struct comedi_cmd *cmd)
 {
 	const struct pcl818_board *board = comedi_board(dev);
+	struct pcl818_private *devpriv = dev->private;
 	int err = 0;
 	int tmp, divisor1 = 0, divisor2 = 0;
 
@@ -1378,6 +1389,7 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	struct comedi_cmd *cmd = &s->async->cmd;
+	struct pcl818_private *devpriv = dev->private;
 	int retval;
 
 	dev_dbg(dev->class_dev, "pcl818_ai_cmd()\n");
@@ -1416,6 +1428,8 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 static int pcl818_ai_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	struct pcl818_private *devpriv = dev->private;
+
 	if (devpriv->irq_blocked > 0) {
 		dev_dbg(dev->class_dev, "pcl818_ai_cancel()\n");
 		devpriv->irq_was_now_closed = 1;
@@ -1501,6 +1515,7 @@ static int pcl818_check(unsigned long iobase)
 static void pcl818_reset(struct comedi_device *dev)
 {
 	const struct pcl818_board *board = comedi_board(dev);
+	struct pcl818_private *devpriv = dev->private;
 
 	if (devpriv->usefifo) {	/*  FIFO shutdown */
 		outb(0, dev->iobase + PCL818_FI_INTCLR);
@@ -1571,6 +1586,7 @@ static int set_rtc_irq_bit(unsigned char bit)
 static void rtc_dropped_irq(unsigned long data)
 {
 	struct comedi_device *dev = (void *)data;
+	struct pcl818_private *devpriv = dev->private;
 	unsigned long flags, tmp;
 
 	switch (devpriv->int818_mode) {
@@ -1620,6 +1636,7 @@ static int rtc_setfreq_irq(int freq)
 static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct pcl818_board *board = comedi_board(dev);
+	struct pcl818_private *devpriv;
 	int ret;
 	unsigned long iobase;
 	unsigned int irq;
@@ -1627,9 +1644,10 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned long pages;
 	struct comedi_subdevice *s;
 
-	ret = alloc_private(dev, sizeof(struct pcl818_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;	/* Can't alloc mem */
+	devpriv = dev->private;
 
 	/* claim our I/O space */
 	iobase = it->options[0];
@@ -1911,7 +1929,9 @@ no_dma:
 
 static void pcl818_detach(struct comedi_device *dev)
 {
-	if (dev->private) {
+	struct pcl818_private *devpriv = dev->private;
+
+	if (devpriv) {
 		pcl818_ai_cancel(dev, devpriv->sub_ai);
 		pcl818_reset(dev);
 		if (devpriv->dma)
diff --git a/drivers/staging/comedi/drivers/pcm3724.c b/drivers/staging/comedi/drivers/pcm3724.c
index 62c22cc..61dca3b 100644
--- a/drivers/staging/comedi/drivers/pcm3724.c
+++ b/drivers/staging/comedi/drivers/pcm3724.c
@@ -154,12 +154,11 @@ static void do_3724_config(struct comedi_device *dev,
 static void enable_chan(struct comedi_device *dev, struct comedi_subdevice *s,
 			int chanspec)
 {
+	struct priv_pcm3724 *priv = dev->private;
 	unsigned int mask;
 	int gatecfg;
-	struct priv_pcm3724 *priv;
 
 	gatecfg = 0;
-	priv = dev->private;
 
 	mask = 1 << CR_CHAN(chanspec);
 	if (s == dev->subdevices)	/*  subdev 0 */
@@ -231,6 +230,7 @@ static int pcm3724_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
 	const struct pcm3724_board *board = comedi_board(dev);
+	struct priv_pcm3724 *priv;
 	unsigned long iobase;
 	unsigned int iorange;
 	int ret, i, n_subdevices;
@@ -238,12 +238,13 @@ static int pcm3724_attach(struct comedi_device *dev,
 	iobase = it->options[0];
 	iorange = board->io_range;
 
-	ret = alloc_private(dev, sizeof(struct priv_pcm3724));
+	ret = alloc_private(dev, sizeof(*priv));
 	if (ret < 0)
 		return -ENOMEM;
+	priv = dev->private;
 
-	((struct priv_pcm3724 *)(dev->private))->dio_1 = 0;
-	((struct priv_pcm3724 *)(dev->private))->dio_2 = 0;
+	priv->dio_1 = 0;
+	priv->dio_2 = 0;
 
 	printk(KERN_INFO "comedi%d: pcm3724: board=%s, 0x%03lx ", dev->minor,
 	       board->name, iobase);
diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index 54d19c9..c0cee11 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -62,7 +62,6 @@ struct pcmad_priv_struct {
 	int differential;
 	int twos_comp;
 };
-#define devpriv ((struct pcmad_priv_struct *)dev->private)
 
 #define TIMEOUT	100
 
@@ -71,6 +70,7 @@ static int pcmad_ai_insn_read(struct comedi_device *dev,
 			      struct comedi_insn *insn, unsigned int *data)
 {
 	const struct pcmad_board_struct *board = comedi_board(dev);
+	struct pcmad_priv_struct *devpriv = dev->private;
 	int i;
 	int chan;
 	int n;
@@ -104,6 +104,7 @@ static int pcmad_ai_insn_read(struct comedi_device *dev,
 static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct pcmad_board_struct *board = comedi_board(dev);
+	struct pcmad_priv_struct *devpriv;
 	int ret;
 	struct comedi_subdevice *s;
 	unsigned long iobase;
@@ -121,9 +122,10 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	ret = alloc_private(dev, sizeof(struct pcmad_priv_struct));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	dev->board_name = board->name;
 
diff --git a/drivers/staging/comedi/drivers/pcmda12.c b/drivers/staging/comedi/drivers/pcmda12.c
index 291ce7c..ad32997 100644
--- a/drivers/staging/comedi/drivers/pcmda12.c
+++ b/drivers/staging/comedi/drivers/pcmda12.c
@@ -86,8 +86,6 @@ struct pcmda12_private {
 	int simultaneous_xfer_mode;
 };
 
-#define devpriv ((struct pcmda12_private *)(dev->private))
-
 static void zero_chans(struct comedi_device *dev)
 {				/* sets up an
 				   ASIC chip to defaults */
@@ -104,6 +102,7 @@ static void zero_chans(struct comedi_device *dev)
 static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcmda12_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -146,6 +145,7 @@ static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcmda12_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -163,6 +163,7 @@ static int pcmda12_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
 	const struct pcmda12_board *board = comedi_board(dev);
+	struct pcmda12_private *devpriv;
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	int ret;
@@ -184,10 +185,11 @@ static int pcmda12_attach(struct comedi_device *dev,
  * Allocate the private structure area.  alloc_private() is a
  * convenient macro defined in comedidev.h.
  */
-	if (alloc_private(dev, sizeof(struct pcmda12_private)) < 0) {
+	if (alloc_private(dev, sizeof(*devpriv)) < 0) {
 		printk(KERN_ERR "cannot allocate private data structure\n");
 		return -ENOMEM;
 	}
+	devpriv = dev->private;
 
 	devpriv->simultaneous_xfer_mode = it->options[1];
 
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index 3d2e6f0..90ae509 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -258,13 +258,6 @@ struct pcmmio_private {
 	struct pcmmio_subdev_private *sprivs;
 };
 
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct pcmmio_private *)dev->private)
-#define subpriv ((struct pcmmio_subdev_private *)s->private)
-
 /* DIO devices are slightly special.  Although it is possible to
  * implement the insn_read/insn_write interface, it is much more
  * useful to applications if you implement the insn_bits interface.
@@ -274,6 +267,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcmmio_subdev_private *subpriv = s->private;
 	int byte_no;
 
 	/* NOTE:
@@ -355,6 +349,7 @@ static int pcmmio_dio_insn_config(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcmmio_subdev_private *subpriv = s->private;
 	int chan = CR_CHAN(insn->chanspec), byte_no = chan / 8, bit_no =
 	    chan % 8;
 	unsigned long ioaddr;
@@ -417,6 +412,7 @@ static int pcmmio_dio_insn_config(struct comedi_device *dev,
 static void switch_page(struct comedi_device *dev, int asic, int page)
 {
 	const struct pcmmio_board *board = comedi_board(dev);
+	struct pcmmio_private *devpriv = dev->private;
 
 	if (asic < 0 || asic >= board->dio_num_asics)
 		return;		/* paranoia */
@@ -435,6 +431,7 @@ static void init_asics(struct comedi_device *dev)
 {				/* sets up an
 				   ASIC chip to defaults */
 	const struct pcmmio_board *board = comedi_board(dev);
+	struct pcmmio_private *devpriv = dev->private;
 	int asic;
 
 	for (asic = 0; asic < board->dio_num_asics; ++asic) {
@@ -473,6 +470,7 @@ static void init_asics(struct comedi_device *dev)
 static void lock_port(struct comedi_device *dev, int asic, int port)
 {
 	const struct pcmmio_board *board = comedi_board(dev);
+	struct pcmmio_private *devpriv = dev->private;
 
 	if (asic < 0 || asic >= board->dio_num_asics)
 		return;		/* paranoia */
@@ -489,6 +487,7 @@ static void lock_port(struct comedi_device *dev, int asic, int port)
 static void unlock_port(struct comedi_device *dev, int asic, int port)
 {
 	const struct pcmmio_board *board = comedi_board(dev);
+	struct pcmmio_private *devpriv = dev->private;
 
 	if (asic < 0 || asic >= board->dio_num_asics)
 		return;		/* paranoia */
@@ -504,6 +503,8 @@ static void unlock_port(struct comedi_device *dev, int asic, int port)
 static void pcmmio_stop_intr(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
+	struct pcmmio_private *devpriv = dev->private;
+	struct pcmmio_subdev_private *subpriv = s->private;
 	int nports, firstport, asic, port;
 
 	asic = subpriv->dio.intr.asic;
@@ -524,8 +525,10 @@ static void pcmmio_stop_intr(struct comedi_device *dev,
 
 static irqreturn_t interrupt_pcmmio(int irq, void *d)
 {
-	int asic, got1 = 0;
 	struct comedi_device *dev = (struct comedi_device *)d;
+	struct pcmmio_private *devpriv = dev->private;
+	struct pcmmio_subdev_private *subpriv;
+	int asic, got1 = 0;
 
 	for (asic = 0; asic < MAX_ASICS; ++asic) {
 		if (irq == devpriv->asics[asic].irq) {
@@ -590,6 +593,7 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
 					 * this is an interrupt subdev,
 					 * and it matches this asic!
 					 */
+					subpriv = s->private;
 					if (subpriv->dio.intr.asic == asic) {
 						unsigned long flags;
 						unsigned oldevents;
@@ -685,6 +689,9 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
 static int pcmmio_start_intr(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
+	struct pcmmio_private *devpriv = dev->private;
+	struct pcmmio_subdev_private *subpriv = s->private;
+
 	if (!subpriv->dio.intr.continuous && subpriv->dio.intr.stop_count == 0) {
 		/* An empty acquisition! */
 		s->async->events |= COMEDI_CB_EOA;
@@ -754,6 +761,7 @@ static int pcmmio_start_intr(struct comedi_device *dev,
 
 static int pcmmio_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct pcmmio_subdev_private *subpriv = s->private;
 	unsigned long flags;
 
 	spin_lock_irqsave(&subpriv->dio.intr.spinlock, flags);
@@ -771,6 +779,7 @@ static int
 pcmmio_inttrig_start_intr(struct comedi_device *dev, struct comedi_subdevice *s,
 			  unsigned int trignum)
 {
+	struct pcmmio_subdev_private *subpriv = s->private;
 	unsigned long flags;
 	int event = 0;
 
@@ -794,6 +803,7 @@ pcmmio_inttrig_start_intr(struct comedi_device *dev, struct comedi_subdevice *s,
  */
 static int pcmmio_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	struct pcmmio_subdev_private *subpriv = s->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	unsigned long flags;
 	int event = 0;
@@ -852,6 +862,7 @@ static int adc_wait_ready(unsigned long iobase)
 static int ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcmmio_subdev_private *subpriv = s->private;
 	int n;
 	unsigned long iobase = subpriv->iobase;
 
@@ -936,7 +947,9 @@ static int ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcmmio_subdev_private *subpriv = s->private;
 	int n;
+
 	for (n = 0; n < insn->n; n++) {
 		unsigned chan = CR_CHAN(insn->chanspec);
 		if (chan < s->n_chan)
@@ -966,6 +979,7 @@ static int wait_dac_ready(unsigned long iobase)
 static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data)
 {
+	struct pcmmio_subdev_private *subpriv = s->private;
 	int n;
 	unsigned iobase = subpriv->iobase, iooffset = 0;
 
@@ -1013,6 +1027,8 @@ static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct pcmmio_board *board = comedi_board(dev);
+	struct pcmmio_private *devpriv;
+	struct pcmmio_subdev_private *subpriv;
 	struct comedi_subdevice *s;
 	int sdev_no, chans_left, n_dio_subdevs, n_subdevs, port, asic,
 	    thisasic_chanct = 0;
@@ -1041,11 +1057,12 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * Allocate the private structure area.  alloc_private() is a
  * convenient macro defined in comedidev.h.
  */
-	if (alloc_private(dev, sizeof(struct pcmmio_private)) < 0) {
+	if (alloc_private(dev, sizeof(*devpriv)) < 0) {
 		printk(KERN_ERR "comedi%d: cannot allocate private data structure\n",
 				dev->minor);
 		return -ENOMEM;
 	}
+	devpriv = dev->private;
 
 	for (asic = 0; asic < MAX_ASICS; ++asic) {
 		devpriv->asics[asic].num = asic;
@@ -1086,6 +1103,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->n_chan = board->n_ai_chans;
 	s->len_chanlist = s->n_chan;
 	s->insn_read = board->ai_rinsn;
+	subpriv = s->private;
 	subpriv->iobase = dev->iobase + 0;
 	/* initialize the resource enable register by clearing it */
 	outb(0, subpriv->iobase + 3);
@@ -1103,6 +1121,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->len_chanlist = s->n_chan;
 	s->insn_read = board->ao_rinsn;
 	s->insn_write = board->ao_winsn;
+	subpriv = s->private;
 	subpriv->iobase = dev->iobase + 8;
 	/* initialize the resource enable register by clearing it */
 	outb(0, subpriv->iobase + 3);
@@ -1123,6 +1142,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->insn_bits = pcmmio_dio_insn_bits;
 		s->insn_config = pcmmio_dio_insn_config;
 		s->n_chan = min(chans_left, MAX_CHANS_PER_SUBDEV);
+		subpriv = s->private;
 		subpriv->dio.intr.asic = -1;
 		subpriv->dio.intr.first_chan = -1;
 		subpriv->dio.intr.asic_chan = -1;
@@ -1217,16 +1237,18 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static void pcmmio_detach(struct comedi_device *dev)
 {
 	const struct pcmmio_board *board = comedi_board(dev);
+	struct pcmmio_private *devpriv = dev->private;
 	int i;
 
 	if (dev->iobase)
 		release_region(dev->iobase, board->total_iosize);
-	for (i = 0; i < MAX_ASICS; ++i) {
-		if (devpriv && devpriv->asics[i].irq)
-			free_irq(devpriv->asics[i].irq, dev);
-	}
-	if (devpriv && devpriv->sprivs)
+	if (devpriv) {
+		for (i = 0; i < MAX_ASICS; ++i) {
+			if (devpriv->asics[i].irq)
+				free_irq(devpriv->asics[i].irq, dev);
+		}
 		kfree(devpriv->sprivs);
+	}
 }
 
 static const struct pcmmio_board pcmmio_boards[] = {
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index feef3d0..bfb350f 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -194,11 +194,6 @@ struct pcmuio_private {
 	struct pcmuio_subdev_private *sprivs;
 };
 
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct pcmuio_private *)dev->private)
 #define subpriv ((struct pcmuio_subdev_private *)s->private)
 
 /* DIO devices are slightly special.  Although it is possible to
@@ -348,6 +343,7 @@ static int pcmuio_dio_insn_config(struct comedi_device *dev,
 static void switch_page(struct comedi_device *dev, int asic, int page)
 {
 	const struct pcmuio_board *board = comedi_board(dev);
+	struct pcmuio_private *devpriv = dev->private;
 
 	if (asic < 0 || asic >= board->num_asics)
 		return;		/* paranoia */
@@ -404,6 +400,7 @@ static void init_asics(struct comedi_device *dev)
 static void lock_port(struct comedi_device *dev, int asic, int port)
 {
 	const struct pcmuio_board *board = comedi_board(dev);
+	struct pcmuio_private *devpriv = dev->private;
 
 	if (asic < 0 || asic >= board->num_asics)
 		return;		/* paranoia */
@@ -419,6 +416,7 @@ static void lock_port(struct comedi_device *dev, int asic, int port)
 static void unlock_port(struct comedi_device *dev, int asic, int port)
 {
 	const struct pcmuio_board *board = comedi_board(dev);
+	struct pcmuio_private *devpriv = dev->private;
 
 	if (asic < 0 || asic >= board->num_asics)
 		return;		/* paranoia */
@@ -434,6 +432,7 @@ static void unlock_port(struct comedi_device *dev, int asic, int port)
 static void pcmuio_stop_intr(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
+	struct pcmuio_private *devpriv = dev->private;
 	int nports, firstport, asic, port;
 
 	asic = subpriv->intr.asic;
@@ -454,8 +453,9 @@ static void pcmuio_stop_intr(struct comedi_device *dev,
 
 static irqreturn_t interrupt_pcmuio(int irq, void *d)
 {
-	int asic, got1 = 0;
 	struct comedi_device *dev = (struct comedi_device *)d;
+	struct pcmuio_private *devpriv = dev->private;
+	int asic, got1 = 0;
 
 	for (asic = 0; asic < MAX_ASICS; ++asic) {
 		if (irq == devpriv->asics[asic].irq) {
@@ -607,6 +607,8 @@ static irqreturn_t interrupt_pcmuio(int irq, void *d)
 static int pcmuio_start_intr(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
+	struct pcmuio_private *devpriv = dev->private;
+
 	if (!subpriv->intr.continuous && subpriv->intr.stop_count == 0) {
 		/* An empty acquisition! */
 		s->async->events |= COMEDI_CB_EOA;
@@ -748,6 +750,7 @@ pcmuio_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct pcmuio_board *board = comedi_board(dev);
+	struct pcmuio_private *devpriv;
 	struct comedi_subdevice *s;
 	int sdev_no, chans_left, n_subdevs, port, asic, thisasic_chanct = 0;
 	unsigned long iobase;
@@ -776,11 +779,12 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * Allocate the private structure area.  alloc_private() is a
  * convenient macro defined in comedidev.h.
  */
-	if (alloc_private(dev, sizeof(struct pcmuio_private)) < 0) {
+	if (alloc_private(dev, sizeof(*devpriv)) < 0) {
 		dev_warn(dev->class_dev,
 			 "cannot allocate private data structure\n");
 		return -ENOMEM;
 	}
+	devpriv = dev->private;
 
 	for (asic = 0; asic < MAX_ASICS; ++asic) {
 		devpriv->asics[asic].num = asic;
@@ -905,16 +909,18 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static void pcmuio_detach(struct comedi_device *dev)
 {
 	const struct pcmuio_board *board = comedi_board(dev);
+	struct pcmuio_private *devpriv = dev->private;
 	int i;
 
 	if (dev->iobase)
 		release_region(dev->iobase, ASIC_IOSIZE * board->num_asics);
-	for (i = 0; i < MAX_ASICS; ++i) {
-		if (devpriv->asics[i].irq)
-			free_irq(devpriv->asics[i].irq, dev);
-	}
-	if (devpriv && devpriv->sprivs)
+	if (devpriv) {
+		for (i = 0; i < MAX_ASICS; ++i) {
+			if (devpriv->asics[i].irq)
+				free_irq(devpriv->asics[i].irq, dev);
+		}
 		kfree(devpriv->sprivs);
+	}
 }
 
 static const struct pcmuio_board pcmuio_boards[] = {
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 5a2953e..2d98959 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1629,7 +1629,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * Allocate the private structure area.  alloc_private() is a
 	 * convenient macro defined in comedidev.h.
 	 */
-	if (alloc_private(dev, sizeof(struct rtdPrivate)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
 	devpriv = dev->private;
 
diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index f7fa940..1bc8891 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -161,8 +161,6 @@ struct rti800_private {
 	int muxgain_bits;
 };
 
-#define devpriv ((struct rti800_private *)dev->private)
-
 #define RTI800_TIMEOUT 100
 
 static irqreturn_t rti800_interrupt(int irq, void *dev)
@@ -177,6 +175,7 @@ static int rti800_ai_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct rti800_private *devpriv = dev->private;
 	int i, t;
 	int status;
 	int chan = CR_CHAN(insn->chanspec);
@@ -229,6 +228,7 @@ static int rti800_ao_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct rti800_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -242,6 +242,7 @@ static int rti800_ao_insn_write(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct rti800_private *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 	int d;
 	int i;
@@ -303,6 +304,7 @@ static int rti800_do_insn_bits(struct comedi_device *dev,
 static int rti800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct rti800_board *board = comedi_board(dev);
+	struct rti800_private *devpriv;
 	unsigned int irq;
 	unsigned long iobase;
 	int ret;
@@ -347,9 +349,10 @@ static int rti800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	ret = alloc_private(dev, sizeof(struct rti800_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	devpriv->adc_mux = it->options[2];
 	devpriv->adc_range = it->options[3];
diff --git a/drivers/staging/comedi/drivers/rti802.c b/drivers/staging/comedi/drivers/rti802.c
index fc16508..501409f 100644
--- a/drivers/staging/comedi/drivers/rti802.c
+++ b/drivers/staging/comedi/drivers/rti802.c
@@ -55,12 +55,11 @@ struct rti802_private {
 	unsigned int ao_readback[8];
 };
 
-#define devpriv ((struct rti802_private *)dev->private)
-
 static int rti802_ao_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct rti802_private *devpriv = dev->private;
 	int i;
 
 	for (i = 0; i < insn->n; i++)
@@ -73,6 +72,7 @@ static int rti802_ao_insn_write(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct rti802_private *devpriv = dev->private;
 	int i, d;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -89,6 +89,7 @@ static int rti802_ao_insn_write(struct comedi_device *dev,
 
 static int rti802_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	struct rti802_private *devpriv;
 	struct comedi_subdevice *s;
 	int i;
 	unsigned long iobase;
@@ -104,8 +105,9 @@ static int rti802_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = "rti802";
 
-	if (alloc_private(dev, sizeof(struct rti802_private)))
+	if (alloc_private(dev, sizeof(*devpriv)))
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret)
diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index 358380f..f7f3c15 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -219,12 +219,6 @@ struct s526_private {
 	unsigned short s526_ai_config;
 };
 
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct s526_private *)dev->private)
-
 static int s526_gpct_rinsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
@@ -255,6 +249,7 @@ static int s526_gpct_insn_config(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct s526_private *devpriv = dev->private;
 	int subdev_channel = CR_CHAN(insn->chanspec);	/*  Unpack chanspec */
 	int i;
 	short value;
@@ -481,6 +476,7 @@ static int s526_gpct_winsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
 {
+	struct s526_private *devpriv = dev->private;
 	int subdev_channel = CR_CHAN(insn->chanspec);	/*  Unpack chanspec */
 	short value;
 	union cmReg cmReg;
@@ -545,6 +541,7 @@ static int s526_ai_insn_config(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct s526_private *devpriv = dev->private;
 	int result = -EINVAL;
 
 	if (insn->n < 1)
@@ -578,6 +575,7 @@ static int s526_ai_insn_config(struct comedi_device *dev,
 static int s526_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			 struct comedi_insn *insn, unsigned int *data)
 {
+	struct s526_private *devpriv = dev->private;
 	int n, i;
 	int chan = CR_CHAN(insn->chanspec);
 	unsigned short value;
@@ -628,6 +626,7 @@ static int s526_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int s526_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			 struct comedi_insn *insn, unsigned int *data)
 {
+	struct s526_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 	unsigned short val;
@@ -660,6 +659,7 @@ static int s526_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int s526_ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			 struct comedi_insn *insn, unsigned int *data)
 {
+	struct s526_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -737,6 +737,7 @@ static int s526_dio_insn_config(struct comedi_device *dev,
 static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct s526_board *board = comedi_board(dev);
+	struct s526_private *devpriv;
 	struct comedi_subdevice *s;
 	int iobase;
 	int i, n;
@@ -769,8 +770,9 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * Allocate the private structure area.  alloc_private() is a
  * convenient macro defined in comedidev.h.
  */
-	if (alloc_private(dev, sizeof(struct s526_private)) < 0)
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
 
 	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret)
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index f90578e..2d99c1c 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -114,8 +114,6 @@ static const struct s626_board s626_boards[] = {
 	 }
 };
 
-#define thisboard ((const struct s626_board *)dev->board_ptr)
-
 struct s626_private {
 	struct pci_dev *pdev;
 	void __iomem *base_addr;
@@ -2512,6 +2510,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 /*   uint16_t	StartVal; */
 /*   uint16_t	index; */
 /*   unsigned int data[16]; */
+	const struct s626_board *thisboard;
 	int result;
 	int i;
 	int ret;
@@ -2582,6 +2581,8 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	dev->board_ptr = s626_boards;
+	thisboard = comedi_board(dev);
+
 	dev->board_name = thisboard->name;
 
 	ret = comedi_alloc_subdevices(dev, 6);
diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index c18314b..c64bd88 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -68,12 +68,6 @@ struct serial2002_private {
 	struct serial2002_range_table_t in_range[32], out_range[32];
 };
 
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct serial2002_private *)dev->private)
-
 struct serial_data {
 	enum { is_invalid, is_digital, is_channel } kind;
 	int index;
@@ -348,6 +342,7 @@ static void serial_write(struct file *f, struct serial_data data)
 
 static int serial_2002_open(struct comedi_device *dev)
 {
+	struct serial2002_private *devpriv = dev->private;
 	int result;
 	char port[20];
 
@@ -653,6 +648,8 @@ err_alloc_configs:
 
 static void serial_2002_close(struct comedi_device *dev)
 {
+	struct serial2002_private *devpriv = dev->private;
+
 	if (!IS_ERR(devpriv->tty) && devpriv->tty)
 		filp_close(devpriv->tty, NULL);
 }
@@ -661,6 +658,7 @@ static int serial2002_di_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct serial2002_private *devpriv = dev->private;
 	int n;
 	int chan;
 
@@ -683,6 +681,7 @@ static int serial2002_do_winsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct serial2002_private *devpriv = dev->private;
 	int n;
 	int chan;
 
@@ -702,6 +701,7 @@ static int serial2002_ai_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct serial2002_private *devpriv = dev->private;
 	int n;
 	int chan;
 
@@ -724,6 +724,7 @@ static int serial2002_ao_winsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct serial2002_private *devpriv = dev->private;
 	int n;
 	int chan;
 
@@ -744,6 +745,7 @@ static int serial2002_ao_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct serial2002_private *devpriv = dev->private;
 	int n;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -757,6 +759,7 @@ static int serial2002_ei_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct serial2002_private *devpriv = dev->private;
 	int n;
 	int chan;
 
@@ -779,13 +782,17 @@ static int serial2002_attach(struct comedi_device *dev,
 			     struct comedi_devconfig *it)
 {
 	const struct serial2002_board *board = comedi_board(dev);
+	struct serial2002_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
 
 	dev_dbg(dev->class_dev, "serial2002: attach\n");
 	dev->board_name = board->name;
-	if (alloc_private(dev, sizeof(struct serial2002_private)) < 0)
+
+	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
+	devpriv = dev->private;
+
 	dev->open = serial_2002_open;
 	dev->close = serial_2002_close;
 	devpriv->port = it->options[0];
-- 
1.7.11

