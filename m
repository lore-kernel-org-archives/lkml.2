Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab1AEWE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 17:04:29 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6474 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1AEWE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 17:04:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 05 Jan 2011 13:54:21 -0800
From: Rakesh Iyer <riyer@nvidia.com>
To: "'Trilok Soni'" <tsoni@codeaurora.org>
CC: "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Wed, 5 Jan 2011 14:02:57 -0800
Subject: RE: [PATCH 1/1] input: tegra-kbc - Add tegra keyboard driver
Thread-Topic: [PATCH 1/1] input: tegra-kbc - Add tegra keyboard driver
Thread-Index: Acuss7TPEPyyvLp3ScqAcYA3anyG4AAaEjWQ
Message-ID: <1FC56210173BB445BD77F608D6FB8D03165A00804D@HQMAIL03.nvidia.com>
References: <1294189382-13657-1-git-send-email-riyer@nvidia.com>
 <4D242D9D.5060305@codeaurora.org>
In-Reply-To: <4D242D9D.5060305@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Trilok.

Thanks for the review.
Most of your comments are being worked on right now.
I have responses to a couple of your comments.

Comment 1
> 
> > +	int *plain_keycode;
> > +	int *fn_keycode;
> > +	struct hrtimer timer;
> > +	struct clk *clk;
> > +};
> > +
> > +static int plain_kbd_keycode[] = {
> > +	/*
> > +	 * Row 0 Unused, Unused, 'W', 'S', 'A', 'Z', Unused, Function,
> > +	 * Row 1 Unused, Unused, Unused, Unused, Unused, Unused, Unused, Menu
> > +	 * Row 2 Unused, Unused, Unused, Unused, Unused, Unused, Alt, Alt2
> > +	 * Row 3 '5', '4', 'R', 'E', 'F', 'D', 'X', Unused,
> > +	 * Row 4 '7', '6', 'T', 'H', 'G', 'V', 'C', SPACEBAR,
> > +	 * Row 5 '9', '8', 'U', 'Y', 'J', 'N', 'B', '|\',
> > +	 * Row 6 Minus, '0', 'O', 'I', 'L', 'K', '<', M,
> > +	 * Row 7 Unused, '+', '}]', '#', Unused, Unused, Unused, Menu,
> > +	 * Row 8 Unused, Unused, Unused, Unused, SHIFT, SHIFT, Unused, Unused,
> > +	 * Row 9 Unused, Unused, Unused, Unused, Unused, Ctrl, Unused, Ctrl,
> > +	 * Row A Unused, Unused, Unused, Unused, Unused, Unused, Unused, Unused,
> > +	 * Row B '{[', 'P', '"', ':;', '/?, '>', Unused, Unused,
> > +	 * Row C 'F10', 'F9', 'BckSpc', '3', '2', Up, Prntscr, Pause
> > +	 * Row D INS, DEL, Unused, Pgup, PgDn, right, Down, Left,
> > +	 * Row E F11, F12, F8, 'Q', F4, F3, '1', F7,
> > +	 * Row F ESC, '~', F5, TAB, F1, F2, CAPLOCK, F6,
> > +	 */
> > +	KEY_RESERVED, KEY_RESERVED, KEY_W, KEY_S,
> > +		KEY_A, KEY_Z, KEY_RESERVED, KEY_FN,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_MENU,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RIGHTALT,
> KEY_LEFTALT,
> > +	KEY_5, KEY_4, KEY_R, KEY_E,
> > +		KEY_F, KEY_D, KEY_X, KEY_RESERVED,
> > +	KEY_7, KEY_6, KEY_T, KEY_H,
> > +		KEY_G, KEY_V, KEY_C, KEY_SPACE,
> > +	KEY_9, KEY_8, KEY_U, KEY_Y,
> > +		KEY_J, KEY_N, KEY_B, KEY_BACKSLASH,
> > +	KEY_MINUS, KEY_0, KEY_O, KEY_I,
> > +		KEY_L, KEY_K, KEY_COMMA, KEY_M,
> > +	KEY_RESERVED, KEY_EQUAL, KEY_RIGHTBRACE, KEY_ENTER,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_MENU,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RIGHTSHIFT, KEY_LEFTSHIFT, KEY_RESERVED,
> KEY_RESERVED,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RIGHTCTRL, KEY_RESERVED,
> KEY_LEFTCTRL,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> KEY_RESERVED,
> > +	KEY_LEFTBRACE, KEY_P, KEY_APOSTROPHE, KEY_SEMICOLON,
> > +		KEY_SLASH, KEY_DOT, KEY_RESERVED, KEY_RESERVED,
> > +	KEY_F10, KEY_F9, KEY_BACKSPACE, KEY_3,
> > +		KEY_2, KEY_UP, KEY_PRINT, KEY_PAUSE,
> > +	KEY_INSERT, KEY_DELETE, KEY_RESERVED, KEY_PAGEUP,
> > +		KEY_PAGEDOWN, KEY_RIGHT, KEY_DOWN, KEY_LEFT,
> > +	KEY_F11, KEY_F12, KEY_F8, KEY_Q,
> > +		KEY_F4, KEY_F3, KEY_1, KEY_F7,
> > +	KEY_ESC, KEY_GRAVE, KEY_F5, KEY_TAB,
> > +		KEY_F1, KEY_F2, KEY_CAPSLOCK, KEY_F6
> > +};
> > +
> > +static int fn_kbd_keycode[] = {
> > +	/*
> > +	 * Row 0 Unused, Unused, 'W', 'S', 'A', 'Z', Unused, Function,
> > +	 * Row 1 Special, Unused, Unused, Unused, Unused, Unused, Unused, Menu
> > +	 * Row 2 Unused, Unused, Unused, Unused, Unused, Unused, Alt, Alt2
> > +	 * Row 3 '5', '4', 'R', 'E', 'F', 'D', 'X', Unused,
> > +	 * Row 4 '7', '6', 'T', 'H', 'G', 'V', 'C', SPACEBAR,
> > +	 * Row 5 '9', '8', 'U', 'Y', 'J', 'N', 'B', '|\',
> > +	 * Row 6 Minus, '0', 'O', 'I', 'L', 'K', '<', M,
> > +	 * Row 7 Unused, '+', '}]', '#', Unused, Unused, Unused, Menu,
> > +	 * Row 8 Unused, Unused, Unused, Unused, SHIFT, SHIFT, Unused, Unused,
> > +	 * Row 9 Unused, Unused, Unused, Unused, Unused, Ctrl, Unused, Control,
> > +	 * Row A Unused, Unused, Unused, Unused, Unused, Unused, Unused, Unused,
> > +	 * Row B '{[', 'P', '"', ':;', '/?, '>', Unused, Unused,
> > +	 * Row C 'F10', 'F9', 'BckSpc', '3', '2', 'Up, Prntscr, Pause
> > +	 * Row D INS, DEL, Unused, Pgup, PgDn, right, Down, Left,
> > +	 * Row E F11, F12, F8, 'Q', F4, F3, '1', F7,
> > +	 * Row F ESC, '~', F5, TAB, F1, F2, CAPLOCK, F6,
> > +	 */
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> KEY_RESERVED,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> KEY_RESERVED,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> KEY_RESERVED,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> KEY_RESERVED,
> > +	KEY_7, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> KEY_RESERVED,
> > +	KEY_9, KEY_8, KEY_4, KEY_RESERVED,
> > +		KEY_1, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +	KEY_RESERVED, KEY_SLASH, KEY_6, KEY_5,
> > +		KEY_3, KEY_2, KEY_RESERVED, KEY_0,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> KEY_RESERVED,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> KEY_RESERVED,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> KEY_RESERVED,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> KEY_RESERVED,
> > +	KEY_RESERVED, KEY_KPASTERISK, KEY_RESERVED, KEY_KPMINUS,
> > +		KEY_KPPLUS, KEY_DOT, KEY_RESERVED, KEY_RESERVED,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_VOLUMEUP, KEY_RESERVED,
> KEY_RESERVED,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_HOME,
> > +		KEY_END, KEY_BRIGHTNESSUP, KEY_VOLUMEDOWN,
> KEY_BRIGHTNESSDOWN,
> > +	KEY_NUMLOCK, KEY_SCROLLLOCK, KEY_MUTE, KEY_RESERVED,
> > +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> KEY_RESERVED,
> > +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> > +		KEY_QUESTION, KEY_RESERVED, KEY_RESERVED,
> KEY_RESERVED
> > +};
> > +
> > +static int tegra_kbc_keycode(struct tegra_kbc *kbc, int r, int c, bool fn_key)
> > +{
> > +	if (!fn_key)
> > +		return kbc->plain_keycode[(r * KBC_MAX_COL) + c];
> > +	else
> > +		return kbc->fn_keycode[(r * KBC_MAX_COL) + c];
> > +}
> > +
> > +#ifdef CONFIG_PM
> > +static int tegra_kbc_open(struct input_dev *dev);
> > +static void tegra_kbc_close(struct input_dev *dev);
> > +static void tegra_kbc_setup_wakekeys(struct tegra_kbc *kbc, bool filter);
> > +
> 
> I don't understand why these are here, why can't we re-arrange them in such
> a way that above is not required.
> 

I am assuming the comment is to question the need for 'tegra_kbc_keycode'.
The keyboard driver can only determine the row and column of the keypress from the hardware and needs the translation to a value.
So we cannot get rid of the translation mechanism. This routine also allows a simpler processing of the function keymaps, so that the multiple callers are kept simple.

Comment 2

> > +
> > +	valid = 0;
> > +	for (i = 0; i < KBC_MAX_KPENT; i++) {
> > +		if (!(i&3))
> > +			kp_ent = *kp_ents++;
> > +
> > +		if (kp_ent & 0x80) {
> > +			cols_val[valid] = kp_ent & 0x7;
> > +			rows_val[valid++] = (kp_ent >> 3) & 0xf;
> > +		}
> > +		kp_ent >>= 8;
> > +	}
> > +
> > +	for (i = 0; i < valid; i++) {
> > +		int k = tegra_kbc_keycode(kbc, rows_val[i], cols_val[i], false);
> > +		if (k == KEY_FN) {
> > +			fn = true;
> > +			break;
> > +		}
> > +	}
> > +
> > +	j = 0;
> > +	for (i = 0; i < valid; i++) {
> > +		int k = tegra_kbc_keycode(kbc, rows_val[i], cols_val[i], fn);
> > +		if (likely(k != -1))
> > +			curr_fifo[j++] = k;
> > +	}
> > +	valid = j;
> > +
> > +	for (i = 0; i < KBC_MAX_KPENT; i++) {
> > +		if (fifo[i] == -1)
> > +			continue;
> > +		for (j = 0; j < valid; j++) {
> > +			if (curr_fifo[j] == fifo[i]) {
> > +				curr_fifo[j] = -1;
> > +				break;
> > +			}
> > +		}
> > +		if (j == valid) {
> > +			input_report_key(kbc->idev, fifo[i], 0);
> > +			fifo[i] = -1;
> > +		}
> > +	}
> > +	for (j = 0; j < valid; j++) {
> > +		if (curr_fifo[j] == -1)
> > +			continue;
> > +		for (i = 0; i < KBC_MAX_KPENT; i++) {
> > +			if (fifo[i] == -1)
> > +				break;
> > +		}
> > +		if (i != KBC_MAX_KPENT) {
> > +			fifo[i] = curr_fifo[j];
> > +			input_report_key(kbc->idev, fifo[i], 1);
> > +		} else
> > +			WARN_ON(1);
> > +	}
> > +}
> > +
> > +static enum hrtimer_restart tegra_kbc_key_repeat_timer(struct hrtimer *handle)
> > +{
> > +	struct tegra_kbc *kbc;
> > +	unsigned long flags;
> > +	u32 val;
> > +	int i;
> > +
> > +	kbc = container_of(handle, struct tegra_kbc, timer);
> > +
> > +	val = (readl(kbc->mmio + KBC_INT_0) >> 4) & 0xf;
> > +	if (val) {
> > +		unsigned long dly;
> > +
> > +		tegra_kbc_report_keys(kbc, kbc->fifo);
> > +
> > +		dly = ((val == 1) ? kbc->repoll_time : 1) * 1000000;
> > +		hrtimer_start(&kbc->timer, ktime_set(0, dly), HRTIMER_MODE_REL);
> > +	} else {
> > +		/* release any pressed keys and exit the loop */
> > +		for (i = 0; i < ARRAY_SIZE(kbc->fifo); i++) {
> > +			if (kbc->fifo[i] == -1)
> > +				continue;
> > +			input_report_key(kbc->idev, kbc->fifo[i], 0);
> > +			kbc->fifo[i] = -1;
> > +		}
> > +
> > +		/* All keys are released so enable the keypress interrupt */
> > +		spin_lock_irqsave(&kbc->lock, flags);
> > +		val = readl(kbc->mmio + KBC_CONTROL_0);
> > +		val |= (1<<3);
> > +		writel(val, kbc->mmio + KBC_CONTROL_0);
> > +		spin_unlock_irqrestore(&kbc->lock, flags);
> > +	}
> > +	return HRTIMER_NORESTART;
> > +}
> > +
> > +static void tegra_kbc_close(struct input_dev *dev)
> > +{
> > +	struct tegra_kbc *kbc = input_get_drvdata(dev);
> > +	unsigned long flags;
> > +	u32 val;
> > +
> > +	spin_lock_irqsave(&kbc->lock, flags);
> > +	val = readl(kbc->mmio + KBC_CONTROL_0);
> > +	val &= ~1;
> > +	writel(val, kbc->mmio + KBC_CONTROL_0);
> > +	spin_unlock_irqrestore(&kbc->lock, flags);
> > +
> > +	clk_disable(kbc->clk);
> > +}
> > +
> > +static void tegra_kbc_setup_wakekeys(struct tegra_kbc *kbc, bool filter)
> > +{
> > +	int i;
> > +	unsigned int rst_val;
> > +
> > +	BUG_ON(kbc->pdata->wake_cnt > KBC_MAX_KEY);
> > +	rst_val = (filter && kbc->pdata->wake_cnt) ? ~0 : 0;
> > +
> > +	for (i = 0; i < KBC_MAX_ROW; i++)
> > +		writel(rst_val, kbc->mmio+KBC_ROW0_MASK_0+i*4);
> > +
> > +	if (filter) {
> > +		for (i = 0; i < kbc->pdata->wake_cnt; i++) {
> > +			u32 val, addr;
> > +			addr = kbc->pdata->wake_cfg[i].row*4 + KBC_ROW0_MASK_0;
> > +			val = readl(kbc->mmio + addr);
> > +			val &= ~(1<<kbc->pdata->wake_cfg[i].col);
> > +			writel(val, kbc->mmio + addr);
> > +		}
> > +	}
> > +}
> 
> could you please explain this functionality in detail? Are you making only selectable
> keys to be able to wakeup system and not all?
> 
Yes, we are making only selectable keys wakeup the system. A 1 bit for a particular 'row,column' indicates that 'row,column' is disabled during suspend. 
The keys that are allowed to wake the system are decided per board and are specified in pdata->wake_cfg.


Please let me know if this is okay. I will incorporate the remaining comments and send out a new patch after successful testing.

Thanks and Regards
Rakesh
