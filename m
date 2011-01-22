Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1AVWZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 17:25:31 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:41657 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1AVWZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 17:25:29 -0500
Date: Sat, 22 Jan 2011 23:25:27 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k/atari - Rename "scc" to "atari_scc"
Message-ID: <alpine.DEB.2.00.1101222324010.28289@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a way too generic name for a global #define and conflicts with a variable
with the same name, causing build errors like:

| drivers/staging/brcm80211/brcmfmac/../util/siutils.c: In function ¡_si_clkctl_cc¢:
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1364: error: expected identifier or ¡(¢ before ¡volatile¢
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1364: error: expected ¡)¢ before ¡(¢ token
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1421: error: incompatible types in assignment
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1422: error: invalid operands to binary &
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1423: error: invalid operands to binary &
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1424: error: invalid operands to binary |
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1425: error: aggregate value used where an integer was expected
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1425: error: aggregate value used where an integer was expected
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1425: error: aggregate value used where an integer was expected
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1425: error: aggregate value used where an integer was expected
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1425: error: aggregate value used where an integer was expected
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1425: error: aggregate value used where an integer was expected
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1425: error: aggregate value used where an integer was expected
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1425: error: aggregate value used where an integer was expected
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1425: error: aggregate value used where an integer was expected
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1425: error: aggregate value used where an integer was expected
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1425: error: aggregate value used where an integer was expected
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1425: error: incompatible type for argument 4 of ¡bcmsdh_reg_write¢
| drivers/staging/brcm80211/brcmfmac/../util/siutils.c:1428: error: invalid operands to binary &
| make[8]: *** [drivers/staging/brcm80211/brcmfmac/../util/siutils.o] Error 1

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This is against the m68k tree. Will split in two parts as atari_scc.c is not
in mainline.

 arch/m68k/atari/ataints.c       |    4 ++--
 arch/m68k/atari/config.c        |    2 +-
 arch/m68k/atari/debug.c         |   14 +++++++-------
 arch/m68k/include/asm/atarihw.h |    2 +-
 drivers/char/atari_scc.c        |   22 +++++++++++-----------
 5 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index eaa23c7..a8eb6ba 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -386,9 +386,9 @@ void __init atari_init_IRQ(void)
 	}
 
 	if (ATARIHW_PRESENT(SCC) && !atari_SCC_reset_done) {
-		scc.cha_a_ctrl = 9;
+		atari_scc.cha_a_ctrl = 9;
 		MFPDELAY();
-		scc.cha_a_ctrl = (char) 0xc0; /* hardware reset */
+		atari_scc.cha_a_ctrl = (char) 0xc0; /* hardware reset */
 	}
 
 	if (ATARIHW_PRESENT(SCU)) {
diff --git a/arch/m68k/atari/config.c b/arch/m68k/atari/config.c
index 055a5bc..273c7e8 100644
--- a/arch/m68k/atari/config.c
+++ b/arch/m68k/atari/config.c
@@ -316,7 +316,7 @@ void __init config_atari(void)
 		ATARIHW_SET(SCC_DMA);
 		printk("SCC_DMA ");
 	}
-	if (scc_test(&scc.cha_a_ctrl)) {
+	if (scc_test(&atari_scc.cha_a_ctrl)) {
 		ATARIHW_SET(SCC);
 		printk("SCC ");
 	}
diff --git a/arch/m68k/atari/debug.c b/arch/m68k/atari/debug.c
index 422770f..92d4488 100644
--- a/arch/m68k/atari/debug.c
+++ b/arch/m68k/atari/debug.c
@@ -62,9 +62,9 @@ static inline void ata_scc_out(char c)
 {
 	do {
 		MFPDELAY();
-	} while (!(scc.cha_b_ctrl & 0x04)); /* wait for tx buf empty */
+	} while (!(atari_scc.cha_b_ctrl & 0x04)); /* wait for tx buf empty */
 	MFPDELAY();
-	scc.cha_b_data = c;
+	atari_scc.cha_b_data = c;
 }
 
 static void atari_scc_console_write(struct console *co, const char *str,
@@ -149,9 +149,9 @@ int atari_scc_console_wait_key(struct console *co)
 {
 	do {
 		MFPDELAY();
-	} while (!(scc.cha_b_ctrl & 0x01)); /* wait for rx buf filled */
+	} while (!(atari_scc.cha_b_ctrl & 0x01)); /* wait for rx buf filled */
 	MFPDELAY();
-	return scc.cha_b_data;
+	return atari_scc.cha_b_data;
 }
 
 int atari_midi_console_wait_key(struct console *co)
@@ -194,9 +194,9 @@ static void __init atari_init_mfp_port(int cflag)
 
 #define SCC_WRITE(reg, val)				\
 	do {						\
-		scc.cha_b_ctrl = (reg);			\
+		atari_scc.cha_b_ctrl = (reg);		\
 		MFPDELAY();				\
-		scc.cha_b_ctrl = (val);			\
+		atari_scc.cha_b_ctrl = (val);		\
 		MFPDELAY();				\
 	} while (0)
 
@@ -248,7 +248,7 @@ static void __init atari_init_scc_port(int cflag)
 	reg3 = (cflag & CSIZE) == CS8 ? 0xc0 : 0x40;
 	reg5 = (cflag & CSIZE) == CS8 ? 0x60 : 0x20 | 0x82 /* assert DTR/RTS */;
 
-	(void)scc.cha_b_ctrl;		/* reset reg pointer */
+	(void)atari_scc.cha_b_ctrl;	/* reset reg pointer */
 	SCC_WRITE(9, 0xc0);		/* reset */
 	LONG_DELAY();			/* extra delay after WR9 access */
 	SCC_WRITE(4, (cflag & PARENB) ? ((cflag & PARODD) ? 0x01 : 0x03)
diff --git a/arch/m68k/include/asm/atarihw.h b/arch/m68k/include/asm/atarihw.h
index 141e544..9c5ab1c 100644
--- a/arch/m68k/include/asm/atarihw.h
+++ b/arch/m68k/include/asm/atarihw.h
@@ -452,7 +452,7 @@ struct SCC
   u_char char_dummy3;
   u_char cha_b_data;
  };
-# define scc ((*(volatile struct SCC*)SCC_BAS))
+# define atari_scc ((*(volatile struct SCC*)SCC_BAS))
 
 /* The ESCC (Z85230) in an Atari ST. The channels are reversed! */
 # define st_escc ((*(volatile struct SCC*)0xfffffa31))
diff --git a/drivers/char/atari_scc.c b/drivers/char/atari_scc.c
index 7d7abe5..e442fb4 100644
--- a/drivers/char/atari_scc.c
+++ b/drivers/char/atari_scc.c
@@ -383,7 +383,7 @@ static int atari_tt_scc_init(void)
 	pr_debug("SCC: init channel A\n");
 	port = &scc_ports[0];
 	port->channel = CHANNEL_A;
-	port->ctrlp = (volatile unsigned char *)&scc.cha_a_ctrl;
+	port->ctrlp = (volatile unsigned char *)&atari_scc.cha_a_ctrl;
 	port->datap = port->ctrlp + 1;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
@@ -422,7 +422,7 @@ static int atari_tt_scc_init(void)
 		pr_debug("SCC: init channel B\n");
 		port = &scc_ports[1];
 		port->channel = CHANNEL_B;
-		port->ctrlp = (volatile unsigned char *)&scc.cha_b_ctrl;
+		port->ctrlp = (volatile unsigned char *)&atari_scc.cha_b_ctrl;
 		port->datap = port->ctrlp + 1;
 		port->port_a = &scc_ports[0];
 		port->port_b = &scc_ports[1];
@@ -490,7 +490,7 @@ static int atari_falcon_scc_init(void)
 	/* Init channel A */
 	port = &scc_ports[0];
 	port->channel = CHANNEL_A;
-	port->ctrlp = (volatile unsigned char *)&scc.cha_a_ctrl;
+	port->ctrlp = (volatile unsigned char *)&atari_scc.cha_a_ctrl;
 	port->datap = port->ctrlp + 2;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
@@ -524,7 +524,7 @@ static int atari_falcon_scc_init(void)
 	/* Init channel B */
 	port = &scc_ports[1];
 	port->channel = CHANNEL_B;
-	port->ctrlp = (volatile unsigned char *)&scc.cha_b_ctrl;
+	port->ctrlp = (volatile unsigned char *)&atari_scc.cha_b_ctrl;
 	port->datap = port->ctrlp + 2;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
@@ -572,7 +572,7 @@ static int atari_st_scc_init(void)
 	port = &scc_ports[1];
 	port->channel = CHANNEL_A;
 	port->ctrlp = (volatile unsigned char *)(escc ? &st_escc.cha_a_ctrl
-						      : &scc.cha_a_ctrl);
+						      : &atari_scc.cha_a_ctrl);
 	port->datap = port->ctrlp + 4;
 	port->port_a = &scc_ports[1];
 	port->port_b = &scc_ports[0];
@@ -606,7 +606,7 @@ static int atari_st_scc_init(void)
 	port = &scc_ports[0];
 	port->channel = CHANNEL_B;
 	port->ctrlp = (volatile unsigned char *)(escc ? &st_escc.cha_b_ctrl
-						      : &scc.cha_b_ctrl);
+						      : &atari_scc.cha_b_ctrl);
 	port->datap = port->ctrlp + 4;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
@@ -1506,9 +1506,9 @@ static int scc_break_ctl(struct tty_struct *tty, int break_state)
 
 #define SCC_WRITE(reg,val)				\
 	do {						\
-		scc.cha_b_ctrl = (reg);			\
+		atari_scc.cha_b_ctrl = (reg);		\
 		scc_delay();				\
-		scc.cha_b_ctrl = (val);			\
+		atari_scc.cha_b_ctrl = (val);		\
 		scc_delay();				\
 	} while (0)
 
@@ -1569,7 +1569,7 @@ static void atari_init_scc_port(int cflag)
 	reg3 = (cflag & CSIZE) == CS8 ? 0xc0 : 0x40;
 	reg5 = (cflag & CSIZE) == CS8 ? 0x60 : 0x20 | 0x82 /* assert DTR/RTS */;
 
-	(void)scc.cha_b_ctrl;		/* reset reg pointer */
+	(void)atari_scc.cha_b_ctrl;	/* reset reg pointer */
 	SCC_WRITE(9, 0xc0);		/* reset */
 	LONG_DELAY();			/* extra delay after WR9 access */
 	SCC_WRITE(4, (cflag & PARENB) ? ((cflag & PARODD) ? 0x01 : 0x03) : 0 |
@@ -1597,10 +1597,10 @@ static void scc_ch_write(char ch)
 	volatile char *p = NULL;
 
 	if (MACH_IS_TT || MACH_IS_FALCON)
-		p = (volatile char *)&scc.cha_b_ctrl;
+		p = (volatile char *)&atari_scc.cha_b_ctrl;
 
 	if (MACH_IS_ST)
-		p = (volatile char *)&scc.cha_b_ctrl;
+		p = (volatile char *)&atari_scc.cha_b_ctrl;
 
 	if (MACH_IS_STE)
 		p = (volatile char *)&st_escc.cha_b_ctrl;
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
