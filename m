Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab1BJNnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:43:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43010 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754566Ab1BJNnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:43:22 -0500
Date: Thu, 10 Feb 2011 13:47:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        david@woodhou.se, david.woodhouse@intel.com
Subject: Re: [RFC PATCH 04/13] Intel(R) MEI Driver
Message-ID: <20110210134711.53aece2f@lxorguk.ukuu.org.uk>
In-Reply-To: <849307$bgs44t@azsmga001.ch.intel.com>
References: <849307$bgs44t@azsmga001.ch.intel.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * error code definition
> + */
> +#define     ESLOTS_OVERFLOW              1
> +#define     ECORRUPTED_MESSAGE_HEADER    1000
> +#define     ECOMPLETE_MESSAGE            1001

Please don't invent error codes, use the Linux system of negative error
codes and pick suitable looking Linux error codes


> +/*
> + * debug kernel print macro define

Shoot all the debug bits and use dev_dbg() - it does all you want and
more and is standardised

> +/*
> + * watch dog definition
> + */
> +#define MEI_WATCHDOG_DATA_SIZE         16
> +#define MEI_START_WD_DATA_SIZE         20
> +#define MEI_WD_PARAMS_SIZE             4
> +#define MEI_WD_STATE_INDEPENDENCE_MSG_SENT       (1 << 0)
> +
> +#define MEI_WD_HOST_CLIENT_ID          1
> +#define MEI_IAMTHIF_HOST_CLIENT_ID     2
> +
> +
> +/* File state */
> +enum file_state {
> +	MEI_FILE_INITIALIZING = 0,
> +	MEI_FILE_CONNECTING,
> +	MEI_FILE_CONNECTED,
> +	MEI_FILE_DISCONNECTING,
> +	MEI_FILE_DISCONNECTED
> +};
> +
> +/* MEI device states */
> +enum mei_states {
> +	MEI_INITIALIZING = 0,
> +	MEI_INIT_CLIENTS,
> +	MEI_ENABLED,
> +	MEI_RESETING,
> +	MEI_DISABLED,
> +	MEI_RECOVERING_FROM_RESET,
> +	MEI_POWER_DOWN,
> +	MEI_POWER_UP
> +};
> +
> +/* init clients  states*/
> +enum mei_init_clients_states {
> +	MEI_START_MESSAGE = 0,
> +	MEI_ENUM_CLIENTS_MESSAGE,
> +	MEI_CLIENT_PROPERTIES_MESSAGE
> +};
> +
> +enum iamthif_states {
> +	MEI_IAMTHIF_IDLE,
> +	MEI_IAMTHIF_WRITING,
> +	MEI_IAMTHIF_FLOW_CONTROL,
> +	MEI_IAMTHIF_READING,
> +	MEI_IAMTHIF_READ_COMPLETE
> +};
> +
> +enum mei_file_transaction_states {
> +	MEI_IDLE,
> +	MEI_WRITING,
> +	MEI_WRITE_COMPLETE,
> +	MEI_FLOW_CONTROL,
> +	MEI_READING,
> +	MEI_READ_COMPLETE
> +};
> +
> +/* MEI CB */
> +enum mei_cb_major_types {
> +	MEI_READ = 0,
> +	MEI_WRITE,
> +	MEI_IOCTL,
> +	MEI_OPEN,
> +	MEI_CLOSE
> +};
> +
> +
> +#define MEI_CONNECT_TIMEOUT             3	/* at least 2 seconds */
> +
> +#define IAMTHIF_STALL_TIMER              12	/* seconds */
> +#define IAMTHIF_READ_TIMER               15	/* seconds */
> +
> +struct mei_cb_private {
> +	struct list_head cb_list;
> +	enum mei_cb_major_types major_file_operations;
> +	void *file_private;
> +	struct mei_message_data request_buffer;
> +	struct mei_message_data response_buffer;
> +	unsigned long information;
> +	unsigned long read_time;
> +	struct file *file_object;
> +};
> +
> +/* Private file struct */
> +struct mei_file_private {
> +	struct list_head link;
> +	struct file *file;
> +	enum file_state state;
> +	wait_queue_head_t tx_wait;
> +	wait_queue_head_t rx_wait;
> +	wait_queue_head_t wait;
> +	int read_pending;
> +	int status;
> +	/* ID of client connected */
> +	u8 host_client_id;
> +	u8 me_client_id;
> +	u8 flow_ctrl_creds;
> +	u8 timer_count;
> +	enum mei_file_transaction_states reading_state;
> +	enum mei_file_transaction_states writing_state;
> +	int sm_state;
> +	struct mei_cb_private *read_cb;
> +};
> +
> +struct io_mei_list {
> +	struct mei_cb_private mei_cb;
> +	int status;
> +	struct iamt_mei_device *device_extension;
> +};
> +
> +/*
> + *  MEI BUS Interface Section
> + */
> +struct mei_msg_hdr {
> +	u32 me_addr:8;
> +	u32 host_addr:8;
> +	u32 length:9;
> +	u32 reserved:6;
> +	u32 msg_complete:1;
> +} __packed;
> +
> +
> +struct hbm_cmd {
> +	u8 cmd:7;
> +	u8 is_response:1;
> +} __packed;
> +
> +
> +struct mei_bus_message {
> +	struct hbm_cmd cmd;
> +	u8 command_specific_data[];
> +} __packed;
> +
> +struct hbm_version {
> +	u8 minor_version;
> +	u8 major_version;
> +} __packed;
> +
> +struct hbm_host_version_request {
> +	struct hbm_cmd cmd;
> +	u8 reserved;
> +	struct hbm_version host_version;
> +} __packed;
> +
> +struct hbm_host_version_response {
> +	struct hbm_cmd cmd;
> +	int host_version_supported;
> +	struct hbm_version me_max_version;
> +} __packed;
> +
> +struct hbm_host_stop_request {
> +	struct hbm_cmd cmd;
> +	u8 reason;
> +	u8 reserved[2];
> +} __packed;
> +
> +struct hbm_host_stop_response {
> +	struct hbm_cmd cmd;
> +	u8 reserved[3];
> +} __packed;
> +
> +struct hbm_me_stop_request {
> +	struct hbm_cmd cmd;
> +	u8 reason;
> +	u8 reserved[2];
> +} __packed;
> +
> +struct hbm_host_enum_request {
> +	struct hbm_cmd cmd;
> +	u8 reserved[3];
> +} __packed;
> +
> +struct hbm_host_enum_response {
> +	struct hbm_cmd cmd;
> +	u8 reserved[3];
> +	u8 valid_addresses[32];
> +} __packed;
> +
> +struct mei_client_properties {
> +	struct guid protocol_name;
> +	u8 protocol_version;
> +	u8 max_number_of_connections;
> +	u8 fixed_address;
> +	u8 single_recv_buf;
> +	u32 max_msg_length;
> +} __packed;
> +
> +struct hbm_props_request {
> +	struct hbm_cmd cmd;
> +	u8 address;
> +	u8 reserved[2];
> +} __packed;
> +
> +
> +struct hbm_props_response {
> +	struct hbm_cmd cmd;
> +	u8 address;
> +	u8 status;
> +	u8 reserved[1];
> +	struct mei_client_properties client_properties;
> +} __packed;
> +
> +struct hbm_client_connect_request {
> +	struct hbm_cmd cmd;
> +	u8 me_addr;
> +	u8 host_addr;
> +	u8 reserved;
> +} __packed;
> +
> +struct hbm_client_connect_response {
> +	struct hbm_cmd cmd;
> +	u8 me_addr;
> +	u8 host_addr;
> +	u8 status;
> +} __packed;
> +
> +struct hbm_client_disconnect_request {
> +	struct hbm_cmd cmd;
> +	u8 me_addr;
> +	u8 host_addr;
> +	u8 reserved[1];
> +} __packed;
> +
> +struct hbm_flow_control {
> +	struct hbm_cmd cmd;
> +	u8 me_addr;
> +	u8 host_addr;
> +	u8 reserved[MEI_FC_MESSAGE_RESERVED_LENGTH];
> +} __packed;
> +
> +struct mei_me_client {
> +	struct mei_client_properties props;
> +	u8 client_id;
> +	u8 flow_ctrl_creds;
> +} __packed;
> +
> +/* private device struct */
> +struct iamt_mei_device {
> +	struct pci_dev *pdev;	/* pointer to pci device struct */
> +	/*
> +	 * lists of queues
> +	 */
> +	 /* array of pointers to  aio lists */
> +	struct io_mei_list *io_list_array[MEI_IO_LISTS_NUMBER];
> +	struct io_mei_list read_list;	/* driver read queue */
> +	struct io_mei_list write_list;	/* driver write queue */
> +	struct io_mei_list write_waiting_list;	/* write waiting queue */
> +	struct io_mei_list ctrl_wr_list;	/* managed write IOCTL list */
> +	struct io_mei_list ctrl_rd_list;	/* managed read IOCTL list */
> +	struct io_mei_list pthi_cmd_list;	/* PTHI list for cmd waiting */
> +
> +	/* driver managed PTHI list for reading completed pthi cmd data */
> +	struct io_mei_list pthi_read_complete_list;
> +	/*
> +	 * list of files
> +	 */
> +	struct list_head file_list;
> +	/*
> +	 * memory of device
> +	 */
> +	unsigned int mem_base;
> +	unsigned int mem_length;
> +	void __iomem *mem_addr;
> +	/*
> +	 * lock for the device
> +	 */
> +	struct mutex device_lock; /* device lock */
> +	int recvd_msg;
> +	struct delayed_work wd_work;	/* watch dog deleye work */
> +	/*
> +	 * hw states of host and fw(ME)
> +	 */
> +	u32 host_hw_state;
> +	u32 me_hw_state;
> +	/*
> +	 * waiting queue for receive message from FW
> +	 */
> +	wait_queue_head_t wait_recvd_msg;
> +	wait_queue_head_t wait_stop_wd;
> +
> +      /*
> +	 * mei device  states
> +	 */
> +	enum mei_states mei_state;
> +	enum  mei_init_clients_states  init_clients_state;
> +	 u16               init_clients_timer;
> +	int stop;
> +
> +	u32 extra_write_index;
> +	u32 rd_msg_buf[128];	/* used for control messages */
> +	u32 wr_msg_buf[128];	/* used for control messages */
> +	u32 ext_msg_buf[8];	/* for control responses */
> +	u32 rd_msg_hdr;
> +
> +	struct hbm_version version;
> +
> +	int host_buffer_is_empty;
> +	struct mei_file_private wd_file_ext;
> +	struct mei_me_client *me_clients; /* Note: memory has to be allocated */
> +	u8 mei_me_clients[32];	/* list of existing clients */
> +	u8 num_mei_me_clients;
> +	u8 me_client_presentation_num ;
> +	u8 me_client_index  ;
> +	u8 mei_host_clients[32];	/* list of existing clients */
> +	u8 current_host_client_id;
> +
> +	int wd_pending;
> +	int wd_stopped;
> +	u16 wd_timeout;	/* seconds ((wd_data[1] << 8) + wd_data[0]) */
> +	unsigned char wd_data[MEI_START_WD_DATA_SIZE];
> +
> +
> +	u16 wd_due_counter;
> +	int asf_mode;
> +	int wd_bypass;	/* if 1, don't refresh watchdog ME client */
> +
> +	struct file *iamthif_file_object;
> +	struct mei_file_private iamthif_file_ext;
> +	int iamthif_ioctl;
> +	int iamthif_canceled;
> +	int iamthif_mtu;
> +	u32 iamthif_timer;
> +	u32 iamthif_stall_timer;
> +	unsigned char *iamthif_msg_buf; /* Note: memory has to be allocated */
> +	u32 iamthif_msg_buf_size;
> +	u32 iamthif_msg_buf_index;
> +	int iamthif_flow_control_pending;
> +	enum iamthif_states iamthif_state;
> +
> +	struct mei_cb_private *iamthif_current_cb;
> +	u8 write_hang;
> +	int need_reset;
> +	long open_handle_count;
> +
> +};
> +
> +/**
> + * read_mei_register - Reads a byte from the mei device
> + *
> + * @dev: the device structure
> + * @offset: offset from which to read the data
> + *
> + * returns the byte read.

But you are using readl which is 32bit and returning 32bit - plus to be
honest they seem to just obfuscate what is going on.

> + * get_host_hw_state - Reads a byte from the mei H_CSR register
> + *
> + * @dev: the device structure
> + *
> + * returns the byte read.
> + */
> +static inline u32 get_host_hw_state(struct iamt_mei_device *dev)
> +{
> +	return read_mei_register(dev, H_CSR);
> +}

Two layers of obfuscation in fact, although this latter one makes more
sense as it does something sensibly named

